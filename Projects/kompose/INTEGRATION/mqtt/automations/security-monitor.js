#!/usr/bin/env node
/**
 * MQTT Automation: Security Event Monitor
 * 
 * This automation monitors security events from Vaultwarden and
 * triggers alerts when suspicious activity is detected.
 * 
 * Prerequisites:
 * - Node.js installed
 * - npm install mqtt axios
 * - Gotify API token configured
 */

const mqtt = require('mqtt');
const axios = require('axios');

// Configuration
const CONFIG = {
  mqtt: {
    broker: process.env.MQTT_BROKER || 'mqtt://core-mqtt:1883',
    username: process.env.MQTT_USERNAME,
    password: process.env.MQTT_PASSWORD
  },
  gotify: {
    url: process.env.GOTIFY_URL || 'http://messaging_gotify:80',
    token: process.env.GOTIFY_TOKEN
  },
  thresholds: {
    failedLogins: 5,          // Alert after N failed attempts
    timeWindow: 300000,       // Within 5 minutes
    suspiciousIPs: []         // Add known suspicious IPs
  },
  topics: {
    subscribe: 'kompose/vault/security/#',
    publish: 'kompose/automation/security-alert'
  }
};

// Track failed login attempts
const failedAttempts = new Map();

// Connect to MQTT broker
console.log('🔌 Connecting to MQTT broker...');
const client = mqtt.connect(CONFIG.mqtt.broker, {
  username: CONFIG.mqtt.username,
  password: CONFIG.mqtt.password,
  clientId: 'automation-security-monitor',
  clean: true,
  reconnectPeriod: 5000
});

client.on('connect', () => {
  console.log('✅ Connected to MQTT broker');
  console.log(`📡 Subscribing to: ${CONFIG.topics.subscribe}`);
  
  client.subscribe(CONFIG.topics.subscribe, { qos: 1 }, (err) => {
    if (err) {
      console.error('❌ Subscription error:', err);
      process.exit(1);
    }
    console.log('✅ Subscribed successfully');
    console.log('🔐 Monitoring security events...\n');
  });
});

client.on('message', async (topic, message) => {
  try {
    const event = JSON.parse(message.toString());
    
    switch (event.event_type) {
      case 'security.failed_login':
        await handleFailedLogin(event);
        break;
      case 'security.login':
        handleSuccessfulLogin(event);
        break;
      case 'security.vault_unlock':
        checkUnusualActivity(event);
        break;
      default:
        logSecurityEvent(event);
    }
    
  } catch (error) {
    console.error('❌ Error processing security event:', error.message);
  }
});

// Handle failed login attempts
async function handleFailedLogin(event) {
  const { email_attempted, ip_address, attempts_count } = event.data;
  const key = `${email_attempted}-${ip_address}`;
  
  console.log(`⚠️  Failed login: ${email_attempted} from ${ip_address} (attempt ${attempts_count})`);
  
  // Track attempts
  if (!failedAttempts.has(key)) {
    failedAttempts.set(key, []);
  }
  
  const attempts = failedAttempts.get(key);
  attempts.push({
    timestamp: Date.now(),
    ...event.data
  });
  
  // Clean old attempts outside time window
  const cutoff = Date.now() - CONFIG.thresholds.timeWindow;
  const recentAttempts = attempts.filter(a => a.timestamp > cutoff);
  failedAttempts.set(key, recentAttempts);
  
  // Check if threshold exceeded
  if (recentAttempts.length >= CONFIG.thresholds.failedLogins) {
    await sendSecurityAlert(
      'critical',
      `Multiple Failed Login Attempts Detected`,
      `Account: ${email_attempted}\nIP: ${ip_address}\nAttempts: ${recentAttempts.length} in last 5 minutes\n\n⚠️  Possible brute force attack!`,
      event
    );
    
    // Clear attempts after alert
    failedAttempts.delete(key);
  }
  
  // Check for suspicious IP
  if (CONFIG.thresholds.suspiciousIPs.includes(ip_address)) {
    await sendSecurityAlert(
      'warning',
      `Login Attempt from Suspicious IP`,
      `Account: ${email_attempted}\nIP: ${ip_address}\n\n⚠️  This IP is flagged as suspicious.`,
      event
    );
  }
}

// Handle successful login
function handleSuccessfulLogin(event) {
  const { user_email, ip_address, device_name } = event.data;
  console.log(`✅ Successful login: ${user_email} from ${ip_address} (${device_name})`);
  
  // Clear any failed attempts for this user
  const keysToDelete = [];
  failedAttempts.forEach((value, key) => {
    if (key.startsWith(user_email)) {
      keysToDelete.push(key);
    }
  });
  keysToDelete.forEach(key => failedAttempts.delete(key));
}

// Check for unusual activity patterns
function checkUnusualActivity(event) {
  const { user_email, device_name } = event.data;
  const hour = new Date().getHours();
  
  // Alert on unusual hours (e.g., 2 AM - 5 AM)
  if (hour >= 2 && hour <= 5) {
    console.log(`⚠️  Unusual hour vault unlock: ${user_email} at ${hour}:00`);
    sendSecurityAlert(
      'info',
      `Vault Unlock at Unusual Hour`,
      `User: ${user_email}\nDevice: ${device_name}\nTime: ${new Date().toLocaleString()}\n\nℹ️  Activity during unusual hours (2 AM - 5 AM).`,
      event
    );
  }
}

// Log all security events
function logSecurityEvent(event) {
  console.log(`📝 Security event: ${event.event_type}`);
}

// Send alert via Gotify
async function sendSecurityAlert(priority, title, message, eventData) {
  const priorityMap = {
    'info': 2,
    'warning': 5,
    'critical': 10
  };
  
  try {
    await axios.post(
      `${CONFIG.gotify.url}/message?token=${CONFIG.gotify.token}`,
      {
        title: `🔐 ${title}`,
        message: message,
        priority: priorityMap[priority] || 5,
        extras: {
          'client::display': {
            'contentType': 'text/markdown'
          },
          'kompose::event': eventData
        }
      }
    );
    
    console.log(`🚨 Alert sent: ${title} (${priority})`);
    
    // Publish automation event
    publishAutomationEvent(priority, title, message, eventData);
    
  } catch (error) {
    console.error('❌ Error sending Gotify alert:', error.message);
  }
}

// Publish automation event to MQTT
function publishAutomationEvent(severity, title, message, sourceEvent) {
  const automationEvent = {
    event_id: generateUUID(),
    timestamp: new Date().toISOString(),
    automation: 'security-monitor',
    severity: severity,
    alert: {
      title: title,
      message: message
    },
    source_event: sourceEvent
  };
  
  client.publish(
    CONFIG.topics.publish,
    JSON.stringify(automationEvent),
    { qos: 2 }  // QoS 2 for critical security events
  );
}

// Generate UUID v4
function generateUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// Cleanup task - run every 10 minutes
setInterval(() => {
  const cutoff = Date.now() - CONFIG.thresholds.timeWindow;
  let cleaned = 0;
  
  failedAttempts.forEach((attempts, key) => {
    const recentAttempts = attempts.filter(a => a.timestamp > cutoff);
    if (recentAttempts.length === 0) {
      failedAttempts.delete(key);
      cleaned++;
    } else {
      failedAttempts.set(key, recentAttempts);
    }
  });
  
  if (cleaned > 0) {
    console.log(`🧹 Cleaned ${cleaned} expired tracking entries`);
  }
}, 600000); // 10 minutes

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n👋 Shutting down security monitor...');
  client.end(true, () => {
    console.log('✅ Disconnected from MQTT broker');
    process.exit(0);
  });
});

// Error handling
process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Unhandled Rejection:', reason);
});

console.log('');
console.log('╔════════════════════════════════════════════════════════╗');
console.log('║  MQTT Security Event Monitor                          ║');
console.log('║  Status: Active                                        ║');
console.log('║  Monitoring: Vaultwarden Security Events              ║');
console.log('╚════════════════════════════════════════════════════════╝');
console.log('');
console.log(`⚙️  Configuration:`);
console.log(`   • Failed login threshold: ${CONFIG.thresholds.failedLogins} attempts`);
console.log(`   • Time window: ${CONFIG.thresholds.timeWindow / 1000 / 60} minutes`);
console.log(`   • Alert endpoint: ${CONFIG.gotify.url}`);
console.log('');
