CREATE MATERIALIZED TABLE price_alerts_slack (
  ts TIMESTAMP_LTZ(3) NOT NULL,
  `text` STRING,
  PRIMARY KEY (ts) NOT ENFORCED
) AS
SELECT
  ts,
  CASE
    WHEN alert_type = 'NEGATIVE_PRICE_OPPORTUNITY'
      THEN CONCAT('⚡ Negative price window at ', CAST(ts AS STRING),
                   ' — forecast €', CAST(forecast_price AS STRING), '/MWh. Charge now.')
    WHEN alert_type = 'PRICE_SPIKE_WARNING'
      THEN CONCAT('⚠️ Price spike expected at ', CAST(ts AS STRING),
                   ' — forecast €', CAST(forecast_price AS STRING),
                   '/MWh (current €', CAST(current_price AS STRING), '). Shift load.')
    ELSE 'Alert (unclassified)'
  END AS `text`
FROM price_alerts
WHERE alert_type IS NOT NULL;
