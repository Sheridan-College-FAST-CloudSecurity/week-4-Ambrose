# Dockerfile

# Use official Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy all files into the container
COPY . .

# Install dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install pytest

# Run tests (optional)
CMD ["pytest"]
