#!/usr/bin/env node
/**
 * MQTT Automation: New Article → Automatic Bookmark
 * 
 * This automation listens for new article publications from Letterpress
 * and automatically creates a bookmark in Linkwarden.
 * 
 * Prerequisites:
 * - Node.js installed
 * - npm install mqtt axios
 * - Linkwarden API token configured
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
  linkwarden: {
    apiUrl: process.env.LINKWARDEN_URL || 'https://links.pivoine.art',
    apiToken: process.env.LINKWARDEN_API_TOKEN,
    collection: process.env.LINKWARDEN_COLLECTION || 'Published Articles'
  },
  topics: {
    subscribe: 'kompose/news/article/published',
    publish: 'kompose/automation/article-to-bookmark'
  }
};

// Connect to MQTT broker
console.log('🔌 Connecting to MQTT broker...');
const client = mqtt.connect(CONFIG.mqtt.broker, {
  username: CONFIG.mqtt.username,
  password: CONFIG.mqtt.password,
  clientId: 'automation-article-to-bookmark',
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
    console.log('👂 Listening for new articles...\n');
  });
});

client.on('message', async (topic, message) => {
  try {
    const event = JSON.parse(message.toString());
    console.log('📰 New article published:', event.data.title);
    
    // Create bookmark in Linkwarden
    const bookmark = await createBookmark(event.data);
    
    // Publish automation success event
    publishAutomationEvent('success', event, bookmark);
    
    console.log('✅ Bookmark created:', bookmark.title);
    console.log('🔗 URL:', bookmark.url);
    console.log('');
    
  } catch (error) {
    console.error('❌ Error processing article:', error.message);
    publishAutomationEvent('error', { error: error.message });
  }
});

client.on('error', (error) => {
  console.error('❌ MQTT error:', error);
});

client.on('offline', () => {
  console.log('⚠️  MQTT client offline, reconnecting...');
});

client.on('reconnect', () => {
  console.log('🔄 Reconnecting to MQTT broker...');
});

// Create bookmark in Linkwarden via API
async function createBookmark(articleData) {
  const bookmarkPayload = {
    url: articleData.published_url,
    title: articleData.title,
    description: articleData.excerpt || '',
    collection: CONFIG.linkwarden.collection,
    tags: articleData.tags || [],
    metadata: {
      source: 'letterpress',
      article_id: articleData.article_id,
      author: articleData.author,
      category: articleData.category,
      published_at: articleData.timestamp
    }
  };
  
  try {
    const response = await axios.post(
      `${CONFIG.linkwarden.apiUrl}/api/v1/bookmarks`,
      bookmarkPayload,
      {
        headers: {
          'Authorization': `Bearer ${CONFIG.linkwarden.apiToken}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    return response.data;
  } catch (error) {
    if (error.response) {
      throw new Error(`Linkwarden API error: ${error.response.status} - ${JSON.stringify(error.response.data)}`);
    }
    throw error;
  }
}

// Publish automation event
function publishAutomationEvent(status, eventData, result = null) {
  const automationEvent = {
    event_id: generateUUID(),
    timestamp: new Date().toISOString(),
    automation: 'article-to-bookmark',
    status: status,
    source_event: eventData,
    result: result
  };
  
  client.publish(
    CONFIG.topics.publish,
    JSON.stringify(automationEvent),
    { qos: 1 }
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

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n👋 Shutting down gracefully...');
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
console.log('║  MQTT Automation: Article → Bookmark                  ║');
console.log('║  Status: Running                                       ║');
console.log('╚════════════════════════════════════════════════════════╝');
console.log('');
