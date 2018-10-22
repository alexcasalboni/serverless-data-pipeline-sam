sam package --template-file template.yaml --s3-bucket YOUR_BUCKET_NAME --output-template-file compiled.yml

echo "Deploying uncompressed stack"
sam deploy --template-file compiled.yml --stack-name serverless-analytics-uncompressed --capabilities CAPABILITY_IAM --region eu-west-1 \
    --parameter-overrides FirehoseCompressionFormat=UNCOMPRESSED AthenaDatabaseName=serverless_analytics AthenaTableName=uncompressed

echo "Deploying compressed stack"
sam deploy --template-file compiled.yml --stack-name serverless-analytics-compressed --capabilities CAPABILITY_IAM --region eu-west-1 \
    --parameter-overrides AthenaDatabaseName=serverless_analytics AthenaTableName=compressed

