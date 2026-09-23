# Real-Time Electricity Price Alerts

Streams German day-ahead electricity prices (aWATTar API) into Confluent Cloud,
forecasts near-term price movement with Flink ML_FORECAST, and pushes alerts
to Slack when a spike or negative-price window is predicted.

## Architecture
HTTP Source (aWATTar) → awattar_prices_raw → [dedupe] → awattar_prices
  → [ML_FORECAST] → price_forecast → [threshold filter] → price_alerts
  → [Slack formatting] → price_alerts_slack → HTTP Sink → Slack

## Business impact
Lets industrial consumers, EV charging operators, and battery storage
operators shift load away from predicted price spikes, and capture
negative-price windows (get paid to consume) before they happen, not after.

## Confluent features used
- HTTP Source & HTTP Sink connectors
- Flink SQL materialized tables (continuous, no manual INSERT INTO)
- ML_FORECAST for time-series forecasting
- Stream Governance (Stream Lineage, Schema Registry)
