# Use the official gitleaks image as base
FROM zricethezav/gitleaks:v8.28.0

# Set maintainer label
LABEL maintainer="security@gitleaks.local"
LABEL version="v8.28.0"
LABEL description="Custom Gitleaks image with enhanced security rules"

# Create a non-root user for security
RUN addgroup -g 1001 gitleaks && \
    adduser -D -s /bin/sh -u 1001 -G gitleaks gitleaks

# Set working directory
WORKDIR /app

# Copy custom configuration
COPY .gitleaks.toml /app/.gitleaks.toml

# Fix permissions - ensure gitleaks user owns the config file
RUN chown -R gitleaks:gitleaks /app && \
    chmod 644 /app/.gitleaks.toml

# Switch to non-root user
USER gitleaks

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD gitleaks version || exit 1

# Set default command
CMD ["gitleaks", "--help"]
