
FROM python:3.11-slim

# Set proxy environment variables for apt and pip
ENV http_proxy=http://proxy-dmz.intel.com:912
ENV https_proxy=http://proxy-dmz.intel.com:912

# Install system dependencies  
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*    

# Install uv
RUN pip install --no-cache-dir uv

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install project dependencies
RUN uv sync

# Expose the port your server runs on
EXPOSE 9001

# Set the default command to run your server
CMD ["uv", "run", "src/server.py", "--host", "0.0.0.0", "--transport", "http"]