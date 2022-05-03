#!/usr/bin/env sh

GIT_ROOT=$(git rev-parse --show-toplevel)
SERVICE="postgres"
OUTPUT_PATH="$GIT_ROOT/deploy/$SERVICE/config"

mkdir -p $OUTPUT_PATH

# init
kubectl create configmap $SERVICE-init --dry-run=client -oyaml  \
--from-file=$GIT_ROOT/scripts/postgres_init.sql \
> $OUTPUT_PATH/${SERVICE}_init.yaml

# run
kubectl create configmap $SERVICE-run --dry-run=client -oyaml \
--from-file=$GIT_ROOT/scripts/postgres_run.sh \
> $OUTPUT_PATH/${SERVICE}_run.yaml

# always
kubectl create configmap $SERVICE-always --dry-run=client -oyaml \
--from-file=$GIT_ROOT/scripts/postgres_always.sh  \
> $OUTPUT_PATH/${SERVICE}_always.yaml