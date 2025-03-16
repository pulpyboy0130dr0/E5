FROM python:3.11-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=${TZ:-Asia/Kolkata}

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y git tzdata && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy all files from the repository instead of cloning
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set up execution permissions
RUN chmod +x run.py

# Define environment variables for Microsoft 365 credentials (Set your values during runtime)
ENV E5_CLIENT_ID="your_client_id"
ENV E5_CLIENT_SECRET="your_client_secret"
ENV E5_REFRESH_TOKEN="your_refresh_token"

# Redirect logs to a file for ZimaOS GUI support
RUN mkdir -p /logs
CMD ["sh", "-c", "python run.py | tee /logs/e5.log"]
