#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "❌ ! RUN THIS SCRIPT WITH SUDO !"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR"

"$SCRIPT_DIR/users.sh"
"$SCRIPT_DIR/install.sh"
"$SCRIPT_DIR/config.sh"
"$SCRIPT_DIR/systemd.sh"
"$SCRIPT_DIR/nginx.sh"
"$SCRIPT_DIR/final.sh"

echo "MAIN SCRIPT DONE"
