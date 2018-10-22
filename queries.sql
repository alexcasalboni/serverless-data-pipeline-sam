CREATE EXTERNAL TABLE parquet (
  name string,
  action string,
  value int
)
STORED AS parquet
LOCATION 's3://serverless-analytics-partitioned-deliverybucket-1t0c6j0dnp1up/firehose/'
TBLPROPERTIES ("parquet.compression"="SNAPPY");


CREATE TABLE partitioned
WITH (
  format = 'Parquet',
  parquet_compression = 'Snappy',
  external_location = 's3://serverless-analytics-partitioned-manually/parquet-partitioned/',
  partitioned_by = ARRAY['name', 'action'] 
)
AS SELECT value, name, action FROM parquet;


CREATE TABLE partitioned_json
WITH (
  format = 'JSON',
  parquet_compression = 'GZIP',
  external_location = 's3://serverless-analytics-partitioned-manually/data/',
  partitioned_by = ARRAY['name', 'action'] 
)
AS SELECT value, name, action FROM partitioned;



SELECT count(*) FROM uncompressed;


SELECT distinct(name) FROM uncompressed;


SELECT name, avg(value) as average
FROM uncompressed
WHERE action = 'refill'
GROUP BY name;


SELECT
    name,
    (SELECT count(value) from uncompressed where name=t1.name and action='charge') as charges_count,
    (SELECT count(value) from uncompressed where name=t1.name and action='refill' ) as refills_count
FROM uncompressed as t1
GROUP BY name;
