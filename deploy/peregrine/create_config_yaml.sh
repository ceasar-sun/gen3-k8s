#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="peregrine"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create secret generic $SERVICE-secret --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/peregrine_settings.py \
> $OUTPUT_PATH/${SERVICE}_secret.yaml

kubectl create secret generic $SERVICE-creds --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/peregrine_creds.json \
> $OUTPUT_PATH/${SERVICE}_creds.yaml

kubectl create configmap $SERVICE-config-helper --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/config_helper.py \
> $OUTPUT_PATH/${SERVICE}_config_helper.yaml

kubectl create secret generic $SERVICE-certs --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/TLS/service.crt \
--from-file=$GIT_ROOT/Secrets/TLS/service.key \
> $OUTPUT_PATH/${SERVICE}_certs.yaml

kubectl create secret generic $SERVICE-service-ca --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/TLS/ca.pem \
> $OUTPUT_PATH/${SERVICE}_service_ca.yaml

kubectl create configmap $SERVICE-setup --dry-run=client -oyaml \
--from-file=$GIT_ROOT/scripts/peregrine_setup.sh \
> $OUTPUT_PATH/${SERVICE}_setup.yaml