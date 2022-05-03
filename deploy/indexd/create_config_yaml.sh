#!/usr/bin/env sh


GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="indexd"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create configmap $SERVICE-config --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/indexd_settings.py \
--from-file=$GIT_ROOT/Secrets/indexd_creds.json \
--from-file=$GIT_ROOT/Secrets/config_helper.py \
--from-file=$GIT_ROOT/scripts/indexd_setup.sh \
> $OUTPUT_PATH/${SERVICE}_config.yaml