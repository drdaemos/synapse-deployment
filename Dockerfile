FROM matrixdotorg/synapse:latest

# Copy config files
COPY homeserver.yaml /data/homeserver.yaml
COPY logging.yaml /data/logging.yaml

EXPOSE 8008 8448