set -e

TARGET_IP=""
TARGET_USER=""
TARGET_PASS=""

IMAGE_TAG="$1"

if [ -z "$IMAGE_TAG" ]; then
    echo "NOTICE: tag is not provided"
fi

sshpass -p "$TARGET_PASS" ssh \
    -o StrictHostKeyChecking=no \
    "$TARGET_USER@$TARGET_IP" << EOF

set -e

cd /opt/mywebapp

sudo /opt/mywebapp/scripts/system/upd_env.sh "$IMAGE_TAG"

sudo systemctl restart mywebapp

EOF

echo "DEPLOYED"