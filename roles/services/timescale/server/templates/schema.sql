CREATE TABLE IF NOT EXISTS metrics (
  time timestamp,
  name text,
  value float,
  labels jsonb
);

SELECT create_hypertable(
  'metrics',
  'time',
  chunk_time_interval => '1h',
  create_default_indexes => TRUE,
  if_not_exists => TRUE
);