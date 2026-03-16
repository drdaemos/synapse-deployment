FROM matrixdotorg/synapse:latest

# Install envsubst (part of gettext package)
USER root
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Copy config files
COPY homeserver.yaml.template /data/homeserver.yaml.template
COPY logging.yaml /data/logging.yaml
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make entrypoint executable
RUN chmod +x /docker-entrypoint.sh

USER 991

EXPOSE 8008 8448

ENTRYPOINT ["/docker-entrypoint.sh"]