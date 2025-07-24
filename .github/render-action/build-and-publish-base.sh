#!/usr/bin/env bash

set -euxo pipefail

DOCKER_TAG="$1"
CURRENT_DATE="$(date "+%Y-%m-%d")"

docker buildx build -f Dockerfile_base -t $DOCKER_TAG:$CURRENT_DATE .
docker image push $DOCKER_TAG:$CURRENT_DATE

docker image tag $DOCKER_TAG:$CURRENT_DATE $DOCKER_TAG:latest
docker image push $DOCKER_TAG:latest
