#!/bin/bash
set -e

FILE="/opt/mywebapp/.env"
TAG="$1"

if grep -q "^APP_TAG=" "$FILE"; then
  sed -i "s/^APP_TAG=.*/APP_TAG=$TAG/" "$FILE"
else
  echo "APP_TAG=$TAG" >> "$FILE"
fi