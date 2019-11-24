CREATE TABLE IF NOT EXISTS metrics (
  time timestamp NOT NULL,
  name text NOT NULL,
  value float NOT NULL,
  labels jsonb
);

SELECT create_hypertable(
  'metrics',
  'time',
  chunk_time_interval => interval '1h',
  create_default_indexes => TRUE,
  if_not_exists => TRUE,
  partitioning_column => 'name',
  number_partitions => 4
);