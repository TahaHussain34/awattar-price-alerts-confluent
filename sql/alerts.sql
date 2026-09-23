CREATE MATERIALIZED TABLE price_alerts (
  ts TIMESTAMP_LTZ(3) NOT NULL,
  current_price DOUBLE,
  forecast_price DOUBLE,
  upper_bound DOUBLE,
  lower_bound DOUBLE,
  alert_type STRING,
  PRIMARY KEY (ts) NOT ENFORCED
) AS
SELECT
  ts, current_price, forecast_price, upper_bound, lower_bound,
  CASE
    WHEN forecast_price < 0 THEN 'NEGATIVE_PRICE_OPPORTUNITY'
    WHEN forecast_price > current_price * 1.3 THEN 'PRICE_SPIKE_WARNING'
  END AS alert_type
FROM price_forecast
WHERE forecast_price < 0 OR forecast_price > current_price * 1.3;
