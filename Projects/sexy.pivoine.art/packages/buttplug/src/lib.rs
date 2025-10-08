#[macro_use]
extern crate tracing;
#[macro_use]
extern crate futures;


mod webbluetooth;
use js_sys;
use tokio_stream::StreamExt;
use crate::webbluetooth::{WebBluetoothCommunicationManagerBuilder};
use buttplug::{
  core::message::{ButtplugServerMessageCurrent,serializer::vec_to_protocol_json},
  server::{ButtplugServerBuilder,ButtplugServerDowngradeWrapper,device::{ServerDeviceManagerBuilder,configuration::{DeviceConfigurationManager}}},
  util::async_manager, core::message::{BUTTPLUG_CURRENT_MESSAGE_SPEC_VERSION, ButtplugServerMessageVariant, serializer::{ButtplugSerializedMessage, ButtplugMessageSerializer, ButtplugServerJSONSerializer}},
  util::device_configuration::load_protocol_configs
};

type FFICallback = js_sys::Function;
type FFICallbackContext = u32;

#[derive(Clone, Copy)]
pub struct FFICallbackContextWrapper(FFICallbackContext);

unsafe impl Send for FFICallbackContextWrapper {
}
unsafe impl Sync for FFICallbackContextWrapper {
}

use console_error_panic_hook;
use tracing_subscriber::{layer::SubscriberExt, Registry};
use tracing_wasm::{WASMLayer, WASMLayerConfig};
use wasm_bindgen::prelude::*;
use std::sync::Arc;
use js_sys::Uint8Array;

pub type ButtplugWASMServer = Arc<ButtplugServerDowngradeWrapper>;

pub fn send_server_message(
  message: &ButtplugServerMessageCurrent,
  callback: &FFICallback,
) {
  let msg_array = [message.clone()];
  let json_msg = vec_to_protocol_json(&msg_array);
  let buf = json_msg.as_bytes();
  {
    let this = JsValue::null();
    let uint8buf = unsafe { Uint8Array::new(&Uint8Array::view(buf)) };
    callback.call1(&this, &JsValue::from(uint8buf));
  }
}

#[no_mangle]
pub fn create_test_dcm(allow_raw_messages: bool) -> DeviceConfigurationManager {
  load_protocol_configs(&None, &None, false)
    .expect("If this fails, the whole library goes with it.")
    .allow_raw_messages(allow_raw_messages)
    .finish()
    .expect("If this fails, the whole library goes with it.")
}

#[no_mangle]
#[wasm_bindgen]
pub fn buttplug_create_embedded_wasm_server(
  callback: &FFICallback,
) -> *mut ButtplugWASMServer {
  console_error_panic_hook::set_once();
  let dcm = create_test_dcm(false);
  let mut sdm = ServerDeviceManagerBuilder::new(dcm);
  sdm.comm_manager(WebBluetoothCommunicationManagerBuilder::default());
  let builder = ButtplugServerBuilder::new(sdm.finish().unwrap());
  let server = builder.finish().unwrap();
  let wrapper = Arc::new(ButtplugServerDowngradeWrapper::new(server));
  let event_stream = wrapper.server_version_event_stream();
  let callback = callback.clone();
  async_manager::spawn(async move {
    pin_mut!(event_stream);
    while let Some(message) = event_stream.next().await {
      send_server_message(&ButtplugServerMessageCurrent::try_from(message).unwrap(), &callback);
    }
  });
  
  Box::into_raw(Box::new(wrapper))
}

#[no_mangle]
#[wasm_bindgen]
pub fn buttplug_free_embedded_wasm_server(ptr: *mut ButtplugWASMServer) {
  if !ptr.is_null() {
    unsafe {
      let _ = Box::from_raw(ptr);
    }
  }
}


#[no_mangle]
#[wasm_bindgen]
pub fn buttplug_client_send_json_message(
  server_ptr: *mut ButtplugWASMServer,
  buf: &[u8],
  callback: &FFICallback,
) {
  let server = unsafe {
    assert!(!server_ptr.is_null());
    &mut *server_ptr
  };
  let callback = callback.clone();
  let serializer = ButtplugServerJSONSerializer::default();
  serializer.force_message_version(&BUTTPLUG_CURRENT_MESSAGE_SPEC_VERSION);
  let input_msg = serializer.deserialize(&ButtplugSerializedMessage::Text(std::str::from_utf8(buf).unwrap().to_owned())).unwrap();
  async_manager::spawn(async move {
    let msg = input_msg[0].clone();
    let response = server.parse_message(msg).await.unwrap();
    if let ButtplugServerMessageVariant::V3(response) = response {
      send_server_message(&response, &callback);
    }

  });
}

#[no_mangle]
#[wasm_bindgen]
pub fn buttplug_activate_env_logger(_max_level: &str) {
  tracing::subscriber::set_global_default(
    Registry::default()
      //.with(EnvFilter::new(max_level))
      .with(WASMLayer::new(WASMLayerConfig::default())),
  )
  .expect("default global");
}
