#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "Pulling latest changes from git..."
git pull origin main
echo "Rebuilding container..."
podman build -t nooklane .
echo "Restarting nooklane container..."
podman rm -f nooklane || true
podman run -d --name nooklane --restart unless-stopped \
    -p 3000:3000 \
    -p 8000:8000 \
    -p 7581:7581 \
    -p 7582:7582/udp \
    -e LIVEKIT_NODE_IP="${LIVEKIT_NODE_IP:-108.180.58.111}" \
    -v /home/fang/services/nooklane-data:/data:Z \
    nooklane
echo "Nooklane updated and running!"
