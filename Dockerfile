# Use the official gitleaks image as base
FROM zricethezav/gitleaks:v8.28.0

# Set maintainer label
LABEL maintainer="security@gitleaks.local"

# Create a non-root user for security
RUN addgroup -g 1001 gitleaks && \
    adduser -D -s /bin/sh -u 1001 -G gitleaks gitleaks

# Set working directory
WORKDIR /app

# Copy custom configuration if needed
COPY .gitleaks.toml /app/.gitleaks.toml

# Switch to non-root user
USER gitleaks

# Set default command
CMD ["gitleaks", "--help"]
