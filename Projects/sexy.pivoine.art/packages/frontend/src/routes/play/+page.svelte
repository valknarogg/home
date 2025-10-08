<script lang="ts">
import { _ } from "svelte-i18n";
import Meta from "$lib/components/meta/meta.svelte";
import {
	ButtplugClient,
	ButtplugMessage,
	ButtplugWasmClientConnector,
	DeviceList,
	SensorReadCmd,
	StopDeviceCmd,
	SensorReading,
	ScalarCmd,
	ScalarSubcommand,
	ButtplugDeviceMessage,
	ButtplugClientDevice,
	SensorType,
} from "@sexy.pivoine.art/buttplug";
import Button from "$lib/components/ui/button/button.svelte";
import { onMount } from "svelte";
import { goto } from "$app/navigation";
import DeviceCard from "$lib/components/device-card/device-card.svelte";
import type { BluetoothDevice } from "$lib/types";

const client = new ButtplugClient("Sexy.Art");
let connected = $state(client.connected);
let scanning = $state(false);
let devices = $state<BluetoothDevice[]>([]);

async function init() {
	const connector = new ButtplugWasmClientConnector();
	// await ButtplugWasmClientConnector.activateLogging("info");
	await client.connect(connector);
	client.on("deviceadded", onDeviceAdded);
	client.on("deviceremoved", (msg: ButtplugDeviceMessage) =>
		devices.splice(msg.DeviceIndex, 1),
	);
	client.on("scanningfinished", () => (scanning = false));
	connector.on("message", handleMessages);
	connected = client.connected;
}

async function startScanning() {
	await client.startScanning();
	scanning = true;
}

async function onDeviceAdded(
	msg: ButtplugDeviceMessage,
	dev: ButtplugClientDevice,
) {
	const device = convertDevice(dev);
	devices.push(device);

	const cmds = device.info.messageAttributes.SensorReadCmd;

	cmds?.forEach(async (cmd) => {
		await client.sendDeviceMessage(
			{ index: device.info.index },
			new SensorReadCmd(device.info.index, cmd.Index, cmd.SensorType),
		);
	});
}

async function handleMessages(messages: ButtplugMessage[]) {
	messages.forEach(async (msg) => {
		await handleMessage(msg);
	});
}

async function handleMessage(msg: ButtplugMessage) {
	if (msg instanceof SensorReading) {
		const device = devices[msg.DeviceIndex];
		if (msg.SensorType === SensorType.Battery) {
			device.batteryLevel = msg.Data[0];
		}
		device.sensorValues[msg.Index] = msg.Data[0];
		device.lastSeen = new Date();
	} else if (msg instanceof DeviceList) {
		devices = client.devices.map(convertDevice);
	}
}

async function handleChange(
	device: BluetoothDevice,
	scalarIndex: number,
	value: number,
) {
	const vibrateCmd = device.info.messageAttributes.ScalarCmd[scalarIndex];
	await client.sendDeviceMessage(
		{ index: device.info.index },
		new ScalarCmd(
			[
				new ScalarSubcommand(
					vibrateCmd.Index,
					(device.actuatorValues[scalarIndex] = value),
					vibrateCmd.ActuatorType,
				),
			],
			device.info.index,
		),
	);
}

async function handleStop(device: BluetoothDevice) {
	await client.sendDeviceMessage(
		{ index: device.info.index },
		new StopDeviceCmd(device.info.index),
	);
	device.actuatorValues = device.info.messageAttributes.ScalarCmd.map(() => 0);
}

function convertDevice(device: ButtplugClientDevice): BluetoothDevice {
	console.log(device);
	return {
		id: device.index as string,
		name: device.name as string,
		batteryLevel: 0,
		isConnected: true,
		lastSeen: new Date(),
		sensorValues: device.messageAttributes.SensorReadCmd
			? device.messageAttributes.SensorReadCmd.map(() => 0)
			: [],
		actuatorValues: device.messageAttributes.ScalarCmd.map(() => 0),
		info: device,
	};
}

const { data } = $props();

onMount(() => {
	if (data.authStatus.authenticated) {
		init();
		return;
	}
	goto("/login");
});
</script>

<Meta title={$_("play.title")} description={$_("play.description")} />

<div
    class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <!-- Global Plasma Background -->
    <div class="absolute inset-0 pointer-events-none">
        <div
            class="absolute top-40 left-1/4 w-80 h-80 bg-gradient-to-r from-primary/16 via-accent/20 to-primary/12 rounded-full blur-3xl animate-blob-slow"
        ></div>
        <div
            class="absolute bottom-40 right-1/4 w-96 h-96 bg-gradient-to-r from-accent/16 via-primary/20 to-accent/12 rounded-full blur-3xl animate-blob-slow animation-delay-5000"
        ></div>
        <div
            class="absolute top-1/3 right-1/3 w-64 h-64 bg-gradient-to-r from-primary/14 via-accent/18 to-primary/10 rounded-full blur-2xl animate-blob-reverse animation-delay-2500"
        ></div>
    </div>

    <div class="container mx-auto py-20 relative px-4">
        <div class="max-w-4xl mx-auto">
            <!-- Header -->
            <div class="text-center mb-12">
                <h1
                    class="text-4xl md:text-5xl font-bold mb-4 bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent"
                >
                    {$_("play.title")}
                </h1>
                <p class="text-lg text-muted-foreground mb-10">
                    {$_("play.description")}
                </p>
                <div class="flex justify-center">
                    <Button
                        size="lg"
                        disabled={!connected || scanning}
                        onclick={startScanning}
                        class="cursor-pointer bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                    >
                        {#if scanning}
                            <div
                                class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"
                            ></div>
                            {$_("play.scanning")}
                        {:else}
                            {$_("play.scan")}
                        {/if}
                    </Button>
                </div>
            </div>
        </div>
    </div>
    <div class="container mx-auto px-4 py-12">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {#if devices}
                {#each devices as device}
                    <DeviceCard
                        {device}
                        onChange={(scalarIndex, val) => handleChange(device, scalarIndex, val)}
                        onStop={() => handleStop(device)}
                    />
                {/each}
            {/if}
        </div>

        {#if devices?.length === 0}
            <div class="text-center py-12">
                <p class="text-muted-foreground text-lg mb-4">
                    {$_("play.no_results")}
                </p>
            </div>
        {/if}
    </div>
</div>
