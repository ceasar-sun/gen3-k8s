#!/bin/bash
# entrypoint bash script for indexd to healthcheck postgres to make sure that 
# postgres is ready before indexd tries to access its database

sleep 2
until (echo > /dev/tcp/postgres-service/5432) >/dev/null 2>&1; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "postgres is ready"

python /indexd/bin/index_admin.py create --username indexd_client --password indexd_client_pass
/dockerrun.sh
