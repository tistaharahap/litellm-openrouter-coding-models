FROM ghcr.io/berriai/litellm:main-stable

# Copy configuration directly into the image
COPY config.yaml /app/litellm_config.yaml

# Set the config path
ENV LITELLM_CONFIG_PATH=/app/litellm_config.yaml

# Expose the default port
EXPOSE 4000

# Override the default command to explicitly load our config
CMD ["--config", "/app/litellm_config.yaml", "--port", "4000"]