FROM alpine:latest

# Install required dependencies
RUN apk add --no-cache bash bc

# Copy the script
COPY simple-interest.sh /usr/local/bin/simple-interest.sh

# Make script executable
RUN chmod +x /usr/local/bin/simple-interest.sh

# Set working directory
WORKDIR /app

# Default entrypoint
ENTRYPOINT ["/usr/local/bin/simple-interest.sh"]

# Example usage:
# docker build -t simple-interest .
# docker run simple-interest -p 1000 -r 5 -t 2