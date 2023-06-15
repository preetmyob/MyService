#!/usr/bin/env bash
set -euo pipefail

ENV=$1
FUNCTION_NAME="MigrationRunner-$ENV"

export DOTNET_ROOT=/var/lib/buildkite-agent/.dotnet
export PATH=$PATH:/var/lib/buildkite-agent/.dotnet
export ENT_API_MYSQL_TEST_VERSION=5.7
echo "--- Running db migration with mysql:${ENT_API_MYSQL_TEST_VERSION}"

cd src/MigrationRunner
aws lambda invoke --function-name enterprise-long-running-infra-api infra.json
formattedSgIds=$(jq '.AlbSecuirtyGroupIds' infra.json | tr -d '" []\n')
echo ${formattedSgIds}

echo "--- Deploying migration lambda with name ${FUNCTION_NAME}"
/var/lib/buildkite-agent/.dotnet/tools/dotnet-lambda deploy-function \
    --config-file aws-lambda-tools-defaults.json \
    --function-name $FUNCTION_NAME \
    --function-security-groups ${formattedSgIds} \
    --environment-variables  DOTNET_ENVIRONMENT=$ENV

echo "--- Wait until lambda is active"
aws lambda wait function-active-v2 --function-name ${FUNCTION_NAME}

echo "--- Running db migration";
result=$(aws lambda invoke --function-name $FUNCTION_NAME --query "FunctionError" /dev/stdout)

if [ $result == null ]; then 
 echo "Run db migration successfully";
 exit 0
else 
 echo "+++"
 echo "Migration failed with response ($result)"
 exit 1
fi
