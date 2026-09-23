CREATE MATERIALIZED TABLE awattar_prices (
  start_ts BIGINT NOT NULL,
  price_time TIMESTAMP_LTZ(3),
  marketprice DOUBLE,
  unit STRING,
  PRIMARY KEY (start_ts) NOT ENFORCED
) AS
SELECT
  COALESCE(start_timestamp, -1) AS start_ts,
  TO_TIMESTAMP_LTZ(start_timestamp, 3) AS price_time,
  marketprice,
  unit
FROM awattar_prices_raw;
