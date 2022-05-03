#!/usr/bin/env bash

if ! command -v python3 &> /dev/null
then
	python="python"
else
	python="python3"
fi

until curl -f -s http://esproxy-service:9200/_cluster/health | $python -c "import sys, json; sys.exit(0 if json.load(sys.stdin)['status'] != 'red' else 1)" 2>/dev/null;
do
  echo "esproxy not ready, waiting..."
  sleep 5
done

echo "esproxy status is green"

exec "$@"