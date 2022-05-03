#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="arborist"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create configmap $SERVICE-setup --dry-run=client -oyaml \
--from-file=$GIT_ROOT/scripts/arborist_setup.sh \
> $OUTPUT_PATH/${SERVICE}_setup.yaml