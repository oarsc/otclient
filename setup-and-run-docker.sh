#!/bin/sh

# Prevent running as root
if [ "$(id -u)" -eq 0 ]; then
  echo "This script should not be executed as root."
  exit 1
fi

VERSION=$(lsb_release -rs | tr -d '.')
IMAGE_NAME="otbi:$VERSION"
CONTAINER_NAME="otb"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^${IMAGE_NAME}$"; then
  echo " [#] Image \"$IMAGE_NAME\" exists."

  if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo " [#] Container \"$CONTAINER_NAME\" exists."

    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
      echo " [#] Container \"$CONTAINER_NAME\" already running. Skipping."
    else
      echo " [#] Running container \"$CONTAINER_NAME\"..."
      docker start -a "$CONTAINER_NAME"
    fi

  else
    echo " [#] Creating and running container \"$CONTAINER_NAME\"..."
    docker run -it --network=host -v $SCRIPT_DIR:/otclient --name "$CONTAINER_NAME" "$IMAGE_NAME"
  fi

else
  echo " [#] Creating image \"$IMAGE_NAME\"..."
  docker build -t "$IMAGE_NAME" -f Dockerfile.$VERSION .

  echo " [#] Creating and running container \"$CONTAINER_NAME\"..."
  docker run -it --network=host -v $SCRIPT_DIR:/otclient --name "$CONTAINER_NAME" "$IMAGE_NAME"
fi
