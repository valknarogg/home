# 🔍 Trace Stack - Your Observability Command Center

> *"When your app goes boom, we tell you why!"* - SigNoz

## What's This All About?

SigNoz is your all-in-one observability platform! Think of it as having X-ray vision for your applications - see traces, metrics, and logs all in one place. It's like Datadog or New Relic, but open-source and running on YOUR infrastructure. When something breaks at 3 AM, SigNoz tells you exactly what, where, and why! 🚨

## The Observability Avengers

### 🎯 SigNoz

**Container**: `trace_app`  
**Image**: `signoz/signoz:v0.96.1`  
**Port**: 8080 (UI), 7070 (exposed externally)  
**Home**: http://localhost:7070

Your main dashboard and query engine:
- 📊 **APM**: Application Performance Monitoring
- 🔍 **Distributed Tracing**: Follow requests across services
- 📈 **Metrics**: CPU, memory, custom metrics
- 📝 **Logs**: Centralized log management
- 🎯 **Alerting**: Get notified when things break
- 🔗 **Service Maps**: Visualize your architecture
- ⏱️ **Performance**: Find bottlenecks
- 🐛 **Error Tracking**: Catch and debug errors

### 🗄️ ClickHouse

**Container**: `trace_clickhouse`  
**Image**: `clickhouse/clickhouse-server:25.5.6`

The speed demon database:
- ⚡ **Columnar Storage**: Insanely fast queries
- 📊 **Analytics**: Perfect for time-series data
- 💾 **Compression**: Stores LOTS of data efficiently
- 🚀 **Performance**: Millions of rows/second
- 📈 **Scalable**: Grows with your needs

### 🐘 ZooKeeper

**Container**: `trace_zookeeper`  
**Image**: `signoz/zookeeper:3.7.1`

The coordinator:
- 🎭 **Orchestration**: Manages distributed systems
- 🔄 **Coordination**: Keeps ClickHouse in sync
- 📋 **Configuration**: Centralized config management

### 📡 OpenTelemetry Collector

**Container**: `trace_otel_collector`  
**Image**: `signoz/signoz-otel-collector:v0.129.6`

The data pipeline:
- 📥 **Receives**: Traces, metrics, logs from apps
- 🔄 **Processes**: Transforms and enriches data
- 📤 **Exports**: Sends to ClickHouse
- 🎯 **Sampling**: Smart data collection
- 🔌 **Flexible**: Supports many data formats

### 🔧 Schema Migrators

**Containers**: `trace_migrator_sync` & `trace_migrator_async`

The database janitors:
- 🗂️ **Migrations**: Set up database schema
- 🔄 **Updates**: Apply schema changes
- 🏗️ **Initialization**: Prepare ClickHouse

## Architecture Overview

```
Your Application
    ↓ (sends telemetry)
OpenTelemetry Collector
    ↓ (stores data)
ClickHouse Database ← ZooKeeper (coordinates)
    ↓ (queries data)
SigNoz UI ← You (investigate issues)
```

## The Three Pillars of Observability

### 1. 📊 Metrics (The Numbers)
What's happening right now?
- Request rate (requests/second)
- Error rate (errors/second)  
- Duration (latency, response time)
- Custom business metrics

**Example**: "API calls are up 200% but error rate is only 1%"

### 2. 🔍 Traces (The Journey)
How did a request flow through your system?
- Distributed tracing across services
- See exact path of each request
- Identify slow operations
- Find where errors occurred

**Example**: "User login → Auth service (50ms) → Database (200ms) → Session storage (10ms)"

### 3. 📝 Logs (The Details)
What exactly happened?
- Application logs
- System logs
- Error messages
- Debug information

**Example**: "ERROR: Database connection timeout at 2024-01-15 03:42:17"

## Configuration Breakdown

### Ports

| Service | Internal | External | Purpose |
|---------|----------|----------|---------|
| SigNoz UI | 8080 | 7070 | Web interface |
| ClickHouse | 9000 | - | Database queries |
| ClickHouse HTTP | 8123 | - | HTTP interface |
| OTel Collector | 4317 | - | gRPC (OTLP) |
| OTel Collector | 4318 | - | HTTP (OTLP) |

### Environment Variables

**Telemetry**:
```bash
TELEMETRY_ENABLED=true       # Send usage stats to SigNoz team
DOT_METRICS_ENABLED=true     # Enable Prometheus metrics
```

**Database**:
```bash
SIGNOZ_TELEMETRYSTORE_CLICKHOUSE_DSN=tcp://clickhouse:9000
```

**Storage**:
```bash
STORAGE=clickhouse           # Backend storage engine
```

## First Time Setup 🚀

### 1. Ensure Dependencies Ready
```bash
# Init ClickHouse (happens automatically)
docker compose up init-clickhouse

# Check if healthy
docker ps | grep trace
```

### 2. Start the Stack
```bash
docker compose up -d
```

This starts:
- ✅ ClickHouse (database)
- ✅ ZooKeeper (coordination)
- ✅ Schema migrations (database setup)
- ✅ SigNoz (UI and query engine)
- ✅ OTel Collector (data collection)

### 3. Access SigNoz
```
URL: http://localhost:7070
```

First login creates admin account!

### 4. Set Up Your First Service

**Install OpenTelemetry SDK** in your app:

**Node.js**:
```bash
npm install @opentelemetry/sdk-node @opentelemetry/auto-instrumentations-node
```

**Python**:
```bash
pip install opentelemetry-distro opentelemetry-exporter-otlp
```

**Go**:
```bash
go get go.opentelemetry.io/otel
```

### 5. Instrument Your Application

**Node.js Example**:
```javascript
const { NodeSDK } = require('@opentelemetry/sdk-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc');

const sdk = new NodeSDK({
  traceExporter: new OTLPTraceExporter({
    url: 'http://localhost:4317', // OTel Collector
  }),
  serviceName: 'my-awesome-app',
});

sdk.start();
```

**Python Example**:
```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

trace.set_tracer_provider(TracerProvider())
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(OTLPSpanExporter(endpoint="http://localhost:4317"))
)
```

### 6. Send Your First Trace

```javascript
// Node.js
const tracer = trace.getTracer('my-app');
const span = tracer.startSpan('do-something');
// ... do work ...
span.end();
```

### 7. View in SigNoz

1. Navigate to http://localhost:7070
2. Go to "Services" tab
3. See your service appear!
4. Click on it to see traces

## Using SigNoz Like a Pro 🎯

### Services View
See all your microservices:
- 📊 Request rate
- ⏱️ Latency (P50, P90, P99)
- ❌ Error rate
- 🔥 Top endpoints

### Traces View
Debug individual requests:
- 🔍 Search by service, operation, duration
- 📈 Visualize request flow
- ⏱️ See exact timings
- 🐛 Find errors with full context

### Metrics View (Dashboards)
Create custom dashboards:
- 📊 Application metrics
- 💻 Infrastructure metrics
- 📈 Business KPIs
- 🎯 Custom queries

### Logs View
Query all your logs:
- 🔍 Full-text search
- 🏷️ Filter by attributes
- ⏰ Time-based queries
- 🔗 Correlation with traces

### Alerts
Set up notifications:
- 📧 Email alerts
- 💬 Slack notifications
- 📱 PagerDuty integration
- 🔔 Custom webhooks

## Common Queries & Dashboards

### Find Slow Requests
```
Operation: GET /api/users
Duration > 1000ms
Time: Last 1 hour
```

### Error Rate Alert
```
Metric: error_rate
Condition: > 5%
Duration: 5 minutes
Action: Send Slack notification
```

### Top 10 Slowest Endpoints
```
Group by: Operation
Sort by: P99 Duration
Limit: 10
```

### Service Dependencies
Auto-generated service map shows:
- 🔗 Which services call which
- 📊 Request volumes
- ⏱️ Latencies between services
- ❌ Error rates

## Instrumenting Different Languages

### Auto-Instrumentation

**Node.js** (Express, Fastify, etc.):
```bash
node --require @opentelemetry/auto-instrumentations-node app.js
```

**Python** (Flask, Django, FastAPI):
```bash
opentelemetry-instrument python app.py
```

**Java** (Spring Boot):
```bash
java -javaagent:opentelemetry-javaagent.jar -jar app.jar
```

### Manual Instrumentation

**Create Custom Spans**:
```javascript
const span = tracer.startSpan('database-query');
span.setAttribute('query', 'SELECT * FROM users');
try {
  const result = await db.query('SELECT * FROM users');
  span.setStatus({ code: SpanStatusCode.OK });
  return result;
} catch (error) {
  span.setStatus({ 
    code: SpanStatusCode.ERROR,
    message: error.message 
  });
  throw error;
} finally {
  span.end();
}
```

## Custom Metrics

**Counter** (things that increase):
```javascript
const counter = meter.createCounter('api_requests');
counter.add(1, { endpoint: '/api/users', method: 'GET' });
```

**Histogram** (measure distributions):
```javascript
const histogram = meter.createHistogram('request_duration');
histogram.record(duration, { endpoint: '/api/users' });
```

**Gauge** (current value):
```javascript
const gauge = meter.createObservableGauge('active_connections');
gauge.addCallback((result) => {
  result.observe(getActiveConnections());
});
```

## Health & Monitoring

### Check Services Health
```bash
# SigNoz
curl http://localhost:8080/api/v1/health

# ClickHouse
docker exec trace_clickhouse clickhouse-client --query="SELECT 1"

# OTel Collector
curl http://localhost:13133/
```

### View Logs
```bash
# SigNoz
docker logs trace_app -f

# ClickHouse
docker logs trace_clickhouse -f

# OTel Collector
docker logs trace_otel_collector -f
```

## Volumes & Data

### ClickHouse Data
```yaml
clickhouse_data → /var/lib/clickhouse/
```
All traces, metrics, logs stored here. **BACKUP REGULARLY!**

### SigNoz Data
```yaml
signoz_data → /var/lib/signoz/
```
SigNoz configuration and metadata.

### ZooKeeper Data
```yaml
zookeeper_data → /bitnami/zookeeper
```
Coordination state.

## Performance Tuning 🚀

### Sampling
Don't send ALL traces (too expensive):
```yaml
# OTel Collector config
processors:
  probabilistic_sampler:
    sampling_percentage: 10  # Sample 10% of traces
```

### Data Retention
Configure how long to keep data:
```sql
-- In ClickHouse
ALTER TABLE traces 
MODIFY TTL timestamp + INTERVAL 30 DAY;
```

### Resource Limits
```yaml
# For ClickHouse
environment:
  MAX_MEMORY_USAGE: 10000000000  # 10GB
```

## Troubleshooting 🔧

**Q: No data appearing in SigNoz?**
```bash
# Check OTel Collector is receiving data
docker logs trace_otel_collector | grep "received"

# Verify app is sending to correct endpoint
# Default: http://localhost:4317

# Check ClickHouse is storing data
docker exec trace_clickhouse clickhouse-client --query="SELECT count() FROM traces"
```

**Q: SigNoz UI won't load?**
```bash
# Check container status
docker ps | grep trace

# View logs
docker logs trace_app

# Verify ClickHouse connection
docker exec trace_app curl clickhouse:9000
```

**Q: High memory usage?**
- Reduce data retention period
- Increase sampling rate
- Allocate more RAM to ClickHouse

**Q: Queries are slow?**
- Check ClickHouse indexes
- Reduce query time range
- Optimize your dashboards

## Advanced Features

### Distributed Tracing
Follow a request across multiple services:
```
Frontend → API Gateway → Auth Service → Database
  50ms   →    100ms    →     30ms     →   200ms
```

### Exemplars
Link metrics to traces:
- Click on a spike in error rate
- Jump directly to failing trace
- Debug with full context

### Service Level Objectives (SLOs)
Set and track SLOs:
- 99.9% uptime
- P95 latency < 200ms
- Error rate < 0.1%

## Real-World Use Cases

### 1. Performance Debugging 🐛
**Problem**: API endpoint suddenly slow  
**Solution**:
1. Check Traces view
2. Filter by slow requests (>1s)
3. See database query taking 950ms
4. Optimize query
5. Verify improvement in metrics

### 2. Error Investigation 🔥
**Problem**: Users reporting 500 errors  
**Solution**:
1. Check error rate dashboard
2. Jump to failing traces
3. See stack trace and logs
4. Identify null pointer exception
5. Deploy fix and monitor

### 3. Capacity Planning 📊
**Problem**: Need to scale before Black Friday  
**Solution**:
1. Review historical metrics
2. Identify bottlenecks
3. Load test and observe traces
4. Scale accordingly
5. Monitor during event

### 4. Microservices Debugging 🕸️
**Problem**: Which service is causing timeouts?  
**Solution**:
1. View service map
2. See latency between services
3. Identify slow service
4. Check its traces
5. Find database connection pool exhausted

## Why SigNoz is Awesome

- 🆓 **Open Source**: Free forever, no limits
- 🚀 **Fast**: ClickHouse is CRAZY fast
- 🎯 **Complete**: Metrics + Traces + Logs in one
- 📊 **Powerful**: Query anything, any way
- 🔒 **Private**: Your data stays on your server
- 💰 **Cost-Effective**: No per-seat pricing
- 🛠️ **Flexible**: Customize everything
- 📈 **Scalable**: Grows with your needs

## Resources

- [SigNoz Documentation](https://signoz.io/docs/)
- [OpenTelemetry Docs](https://opentelemetry.io/docs/)
- [ClickHouse Manual](https://clickhouse.com/docs/)
- [SigNoz GitHub](https://github.com/SigNoz/signoz)

---

*"You can't fix what you can't see. SigNoz makes everything visible."* - Observability Wisdom 🔍✨
