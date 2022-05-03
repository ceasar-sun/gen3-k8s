#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="guppy"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create configmap $SERVICE-manifest --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/guppy_config.json \
> $OUTPUT_PATH/${SERVICE}_manifest.yaml

kubectl create configmap $SERVICE-wait --dry-run=client -oyaml \
--from-file=$GIT_ROOT/scripts/wait_for_esproxy.sh \
> $OUTPUT_PATH/${SERVICE}_wait.yaml

kubectl create secret generic $SERVICE-certs --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/TLS/service.crt \
--from-file=$GIT_ROOT/Secrets/TLS/service.key \
> $OUTPUT_PATH/${SERVICE}_certs.yaml

kubectl create secret generic $SERVICE-service-ca --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/TLS/ca.pem \
> $OUTPUT_PATH/${SERVICE}_service_ca.yaml
