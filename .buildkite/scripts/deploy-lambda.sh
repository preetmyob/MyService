#!/usr/bin/env bash
export DOTNET_ROOT=/var/lib/buildkite-agent/.dotnet
export PATH=$PATH:/var/lib/buildkite-agent/.dotnet
#env
#echo $PATH
#which dotnet
ls -al /var/lib/buildkite-agent/.dotnet/tools
cd src/api/Enterprise.Platform.MyService.Api
/var/lib/buildkite-agent/.dotnet/tools/dotnet-lambda deploy-function 
