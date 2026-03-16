#!/bin/bash
set -e

echo "Processing homeserver.yaml from template..."

# Replace environment variables in template
envsubst < /data/homeserver.yaml.template > /data/homeserver.yaml

echo "Configuration generated successfully"
echo "Server name: ${SERVER_NAME}"
echo "Database host: ${PGHOST}"

# Handle signing key
SIGNING_KEY_PATH="/data/homeserver.signing.key"

if [ -n "$SYNAPSE_SIGNING_KEY" ]; then
    echo "Using signing key from environment variable"
    echo "$SYNAPSE_SIGNING_KEY" > "$SIGNING_KEY_PATH"
elif [ -f "$SIGNING_KEY_PATH" ]; then
    echo "Using existing signing key from file"
else
    echo "WARNING: No signing key found. Synapse will generate one."
    echo "IMPORTANT: After first run, copy the key to SYNAPSE_SIGNING_KEY env var:"
    echo "  cat /data/homeserver.signing.key"
fi

# Start Synapse
exec python -m synapse.app.homeserver --config-path /data/homeserver.yaml
