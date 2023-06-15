#!/usr/bin/env bash
set -euo pipefail

function die { echo "$*" 1>&2 ; exit 1; }

BUILD_NUMBER=${BUILD_NUMBER:-local}
BRANCH=${BRANCH:-local}
LOCAL_REF="backgroundprocess:latest"
APP_IMAGE="380218177284.dkr.ecr.ap-southeast-2.amazonaws.com/backgroundprocess"

aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 380218177284.dkr.ecr.ap-southeast-2.amazonaws.com || die "can't build"

docker build -t ${LOCAL_REF} -f src/BackgroundTasks/Primitives.BackgroundTasks/Dockerfile . || die "can't build"

docker tag ${LOCAL_REF} ${APP_IMAGE}:${BUILD_NUMBER}

if [ ${BRANCH} = "main" ]; then
    docker tag ${LOCAL_REF} ${APP_IMAGE}:latest
fi

docker push -a ${APP_IMAGE}
