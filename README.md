# Serverless Data Pipeline - SAM Template
Serverless Data Pipeline powered by Kinesis Firehose, API Gateway, Lambda, S3, and Athena

## Resources list

This stack will create the following resources:

* An API Gateway endpoint that you can use to `track` events by submitting any JSON data via the HTTP POST method
* A Kinesis Firehose Delivery Stream that will buffer, optionally compress, and write each record into S3
* A Lambda Function to process/manipulate/clean/skip records before they get written into S3
* An S3 Bucket that will contain all the collected data
* Three Athena Named Queries to get started quickly with serverless queries
* An IAM Role and Policy for API Gateway
* An IAM Role and Policy for Kinesis Firehose


## Gotchas

* The architecture is 100% serverless (no hourly costs, no serveres to manage)
* The API endpoint is publicly accessible (e.g. any browser or anonymous website user can potentially submit new records/events)
* Data is not serverside-encrypted on S3, but you can customize the template to make sure Kinesis Firhose will take care of that as well
* You can configure Kinesis Firehose's buffering (see Parameters below)
* Athena's Named Queries cannot be updated (deployments will fail, unless you create a new Query with a different logical name)
* Make sure the S3 bucket is empty when you delete the stack

## Parameters

* ApiStageName: The API Gateway Stage name (e.g. dev, prod, etc.)
* FirehoseS3Prefix: The S3 Key prefix for Kinesis Firehose
* FirehoseCompressionFormat: The compression format used by Kinesis Firehose
* FirehoseBufferingInterval: How long Firehose will wait before writing a new batch into S3
* FirehoseBufferingSize: The maximum batch size in MB
* LambdaTimeout: Lambda's max execution time in seconds
* LambdaMemorySize: Lambda's max memory configuration
* AthenaDatabaseName: The Athena database name
* AthenaTableName: The Athena table name

## Outputs

* TrackURL: The public URL to submit new records
* BucketName: The bucket where data will be stored
* FunctionName: The Lambda Function that will process Firehose records
