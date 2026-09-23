CREATE MATERIALIZED TABLE price_forecast (
  ts TIMESTAMP_LTZ(3) NOT NULL,
  current_price DOUBLE,
  forecast_price DOUBLE,
  upper_bound DOUBLE,
  lower_bound DOUBLE,
  PRIMARY KEY (ts) NOT ENFORCED
) AS
SELECT
  ts,
  current_price,
  forecast[1].forecast_value AS forecast_price,
  forecast[1].upper_bound AS upper_bound,
  forecast[1].lower_bound AS lower_bound
FROM (
  SELECT
    COALESCE(price_time, CAST('1970-01-01 00:00:00' AS TIMESTAMP_LTZ(3))) AS ts,
    marketprice AS current_price,
    ML_FORECAST(
      marketprice, price_time,
      JSON_OBJECT('minTrainingSize' VALUE 5, 'horizon' VALUE 3)
    ) OVER (ORDER BY price_time) AS forecast
  FROM awattar_prices
)
WHERE CARDINALITY(forecast) >= 1;
