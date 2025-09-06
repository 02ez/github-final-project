# Multi-stage Dockerfile for Simple Interest Calculator
# Provides production-ready containerized deployment

# Build stage
FROM ubuntu:22.04 AS builder

# Metadata
LABEL org.opencontainers.image.title="Simple Interest Calculator"
LABEL org.opencontainers.image.description="Production-ready Bash CLI for computing simple and compound interest"
LABEL org.opencontainers.image.url="https://github.com/02ez/github-final-project"
LABEL org.opencontainers.image.documentation="https://github.com/02ez/github-final-project/tree/main/docs"
LABEL org.opencontainers.image.source="https://github.com/02ez/github-final-project"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    bc \
    bash \
    shellcheck \
    bats \
    curl \
    jq \
    make \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r calculator && useradd -r -g calculator calculator

# Set working directory
WORKDIR /app

# Copy source files
COPY simple-interest.sh .
COPY tests/ tests/
COPY Makefile .
COPY docs/ docs/
COPY README.md LICENSE CHANGELOG.md ./

# Make script executable and run tests
RUN chmod +x simple-interest.sh && \
    make test && \
    make build

# Production stage
FROM ubuntu:22.04 AS production

# Install runtime dependencies only
RUN apt-get update && \
    apt-get install -y \
    bc \
    bash \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user
RUN groupadd -r calculator && useradd -r -g calculator calculator

# Create application directory
WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/simple-interest.sh .
COPY --from=builder /app/README.md .
COPY --from=builder /app/LICENSE .

# Create symbolic link for global access
RUN ln -s /app/simple-interest.sh /usr/local/bin/simple-interest

# Set ownership
RUN chown -R calculator:calculator /app

# Switch to non-root user
USER calculator

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /app/simple-interest.sh -p 100 -r 5 -t 1 >/dev/null || exit 1

# Default command
ENTRYPOINT ["/app/simple-interest.sh"]
CMD ["-h"]

# Expose volume for output (if needed)
VOLUME ["/output"]

# Development stage (for development container)
FROM builder AS development

# Install additional development tools
RUN apt-get update && \
    apt-get install -y \
    git \
    vim \
    nano \
    tree \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Set up development environment
USER calculator
WORKDIR /workspace

# Default to bash for development
CMD ["/bin/bash"]