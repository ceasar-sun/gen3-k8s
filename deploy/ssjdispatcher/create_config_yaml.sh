#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="ssjdispatcher"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create secret generic $SERVICE-creds --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/ssj_creds.json \
> $OUTPUT_PATH/${SERVICE}_creds.yaml
