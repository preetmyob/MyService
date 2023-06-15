#!/usr/bin/env bash
set -euo pipefail

function die { echo "$*" 1>&2 ; exit 1; }

#swap directory to root directory
THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$( realpath -s "${THIS_SCRIPT_DIR}/../../" )"
cd "${ROOT_DIR}"

#TODO - parameterize
export ENT_API_MYSQL_TEST_VERSION=8.0
echo "--- Coverage test with mysql:${ENT_API_MYSQL_TEST_VERSION}"
/var/lib/buildkite-agent/.dotnet/dotnet test src/api/Enterprise.Platform.MyService.Api.Tests -l:"console;verbosity=normal" --nologo --collect:"XPlat Code Coverage" --results-directory ./coverage/ -v q
echo "Ran dotnet test with mysql ${ENT_API_MYSQL_TEST_VERSION}"

latest_folder=$(find coverage -type d -printf '%T@ %p\n' 2>/dev/null | sort -r | head -n 1)
latest_folder=$(awk '{print $2}' <<< "$latest_folder")
echo "latest folder: $latest_folder"

#use xmllint to parse the first line and extract the value of the "line-rate" key
coverage_stat=$(xmllint --xpath "string(//coverage[1]/@line-rate)" $latest_folder/coverage.cobertura.xml)
echo "..."
echo "Code coverage: $coverage_stat"

#set code coverage cutoff and check if value is above it
COVERAGE_CUTOFF=90

if awk "BEGIN {exit !($coverage_stat > $COVERAGE_CUTOFF / 100 )}"
then
    echo "Passed: test coverage is above the $COVERAGE_CUTOFF% cutoff."
else
    die "Failure: test coverage isn't above the $COVERAGE_CUTOFF% cutoff."
fi
