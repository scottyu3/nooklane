#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "Pulling latest changes from git..."
git pull origin main
echo "Rebuilding container..."
podman build -t nooklane .
echo "Restarting nooklane container..."
podman rm -f nooklane || true
ENV_ARGS=()
if [ -f .env ]; then
    ENV_ARGS+=(--env-file .env)
    # Source .env so variables can be used in script defaults
    set -a
    source .env
    set +a
fi

if [ -z "$LIVEKIT_NODE_IP" ]; then
    DETECTED_IP=$(curl -4 -s --connect-timeout 5 ifconfig.me || true)
    if [ -n "$DETECTED_IP" ]; then
        LIVEKIT_NODE_IP="$DETECTED_IP"
        echo "Detected external IP: $LIVEKIT_NODE_IP"
    fi
fi

podman run -d --name nooklane --restart unless-stopped \
    -p 3000:3000 \
    -p 8000:8000 \
    -p 7581:7581 \
    -p 7582:7582/udp \
    -e REFLEX_API_URL="${REFLEX_API_URL:-https://town.scottyu.ca}" \
    -e LIVEKIT_NODE_IP="${LIVEKIT_NODE_IP}" \
    "${ENV_ARGS[@]}" \
    -v /home/fang/services/nooklane-data:/data:Z \
    nooklane
echo "Nooklane updated and running!"
