#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="esproxy"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create configmap $SERVICE-wait --dry-run=client -oyaml \
--from-file=$GIT_ROOT/scripts/wait_for_esproxy.sh \
> $OUTPUT_PATH/${SERVICE}_wait.yaml
