#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="fence"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

kubectl create secret generic $SERVICE-config --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/fence-config.yaml \
> $OUTPUT_PATH/${SERVICE}_config.yaml

kubectl create configmap $SERVICE-user --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/user.yaml \
> $OUTPUT_PATH/${SERVICE}_user.yaml

kubectl create secret generic $SERVICE-certs --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/TLS/service.crt \
--from-file=$GIT_ROOT/Secrets/TLS/service.key \
> $OUTPUT_PATH/${SERVICE}_certs.yaml

kubectl create secret generic $SERVICE-service-ca --dry-run=client -oyaml \
--from-file=$GIT_ROOT/Secrets/TLS/ca.pem \
> $OUTPUT_PATH/${SERVICE}_service_ca.yaml

find $GIT_ROOT/Secrets/fenceJwtKeys -type f -name *.pem \
| xargs dirname \
| head -n1 \
| xargs -I{} kubectl create secret generic $SERVICE-jwt-keys \
--dry-run=client -oyaml \
--from-file={} \
> $OUTPUT_PATH/${SERVICE}_jwt_keys.yaml

kubectl create configmap $SERVICE-setup --dry-run=client -oyaml \
--from-file=$GIT_ROOT/scripts/fence_setup.sh \
> $OUTPUT_PATH/${SERVICE}_setup.yaml
