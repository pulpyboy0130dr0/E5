FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y git tzdata && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy all files from the local project directory into the container
COPY . /app

# Ensure run.py exists before setting permissions
RUN if [ -f /app/run.py ]; then chmod +x /app/run.py; else echo "Warning: run.py not found!"; fi

# Check if requirements.txt exists before installing
RUN if [ -f /app/requirements.txt ]; then pip install --no-cache-dir -r /app/requirements.txt; else echo "Warning: requirements.txt not found!"; fi

# Define environment variables (Use a .env file instead for security)
ARG E5_CLIENT_ID
ARG E5_CLIENT_SECRET
ARG E5_REFRESH_TOKEN

# Redirect logs to a file for ZimaOS GUI support
RUN mkdir -p /logs
CMD ["sh", "-c", "python /app/run.py | tee /logs/e5.log"]
