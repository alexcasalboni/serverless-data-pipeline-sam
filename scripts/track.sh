stack="sam-sls-pipeline"
url=$(aws cloudformation describe-stacks --stack-name $stack --query Stacks[0].Outputs[0].OutputValue --output text)
record='{"name": "John", "action": "charge", "value": 100}'

curl \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$record" \
    $url