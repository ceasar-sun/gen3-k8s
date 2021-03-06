#!/bin/bash
# entrypoint script for arborist to setup db

sleep 2
until (echo > /dev/tcp/postgres-service/5432) >/dev/null 2>&1; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "postgres is ready"

update-ca-certificates

./migrations/latest
./bin/arborist
