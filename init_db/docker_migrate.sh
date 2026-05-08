#!/bin/bash

set -e

export PGPASSWORD=$(jq -r '.db.password' /etc/mywebapp/config.json)

until psql \
  -h $(jq -r '.db.host' /etc/mywebapp/config.json) \
  -p $(jq -r '.db.port' /etc/mywebapp/config.json) \
  -U $(jq -r '.db.user' /etc/mywebapp/config.json) \
  -d $(jq -r '.db.name' /etc/mywebapp/config.json) \
  -c '\q'
do
  echo "waiting for DB..."
  sleep 1
done

psql \
  -h $(jq -r '.db.host' /etc/mywebapp/config.json) \
  -p $(jq -r '.db.port' /etc/mywebapp/config.json) \
  -U $(jq -r '.db.user' /etc/mywebapp/config.json) \
  -d $(jq -r '.db.name' /etc/mywebapp/config.json) \
  -f ./init_db/init.sql

echo "migration complete"

echo "starting app..."

exec "$@"