#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="tube"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create configmap $SERVICE-etl-mapping --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/etlMapping.yaml \
> $OUTPUT_PATH/${SERVICE}_etl_mapping.yaml

kubectl create secret generic $SERVICE-creds --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/etl_creds.json \
> $OUTPUT_PATH/${SERVICE}_creds.yaml
