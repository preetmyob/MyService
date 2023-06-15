#!/usr/bin/env bash

function die { echo "$*" 1>&2 ; exit 1; }
commit_hash=$(git rev-parse --short HEAD)
stack_name="EnterprisePlatformAPIGatewayRoutes"
apigateway_id=$(aws apigatewayv2 get-apis --query 'Items[?Name==`enterprise-platform-api-gateway`].ApiId' --output text)
integration_id=$(aws apigatewayv2 get-integrations --api-id $apigateway_id --query 'Items[?contains(IntegrationUri,`primitives`)].IntegrationId' --output text)

echo "apigateway_id: $apigateway_id"
echo "integration_id: $integration_id"
echo "commit_hash: $commit_hash"

stack_details=$((aws cloudformation describe-stacks --stack-name "$stack_name") 2>&1) || true

if [[ $stack_details == *"CREATE_IN_PROGRESS"* || $stack_details == *"ROLLBACK_COMPLETE"* ]] ;
then
    die "ERROR: Cannot deploy stack or create change set when the CFN stack is in state \"CREATE_IN_PROGRESS\" or \"ROLLBACK_COMPLETE\"."
fi

 if [[ $stack_details == *"Stacks"* && $stack_details != *"error"* ]]
    then
        echo "..stackname \"$stack_name\" already exists. updating stack..."
        aws cloudformation update-stack --template-body file://CloudFormationTemplates/ApiGatewayRoutes/ApiGatewayRoutes.yml --stack-name "$stack_name" --parameters ParameterKey=APIGatewayId,ParameterValue="$apigateway_id" ParameterKey=IntegrationId,ParameterValue="$integration_id" --tags Key=CommitHash,Value="$commit_hash"
    else
        echo "..stack doesn't exist. creating stack..." 
        aws cloudformation create-stack --template-body file://CloudFormationTemplates/ApiGatewayRoutes/ApiGatewayRoutes.yml --stack-name "$stack_name" --parameters ParameterKey=APIGatewayId,ParameterValue="$apigateway_id" ParameterKey=IntegrationId,ParameterValue="$integration_id" --tags Key=CommitHash,Value="$commit_hash"
    fi

aws cloudformation describe-stack-events --stack-name $stack_name --output text