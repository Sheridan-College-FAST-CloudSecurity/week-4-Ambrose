# Use the official Python 3.12 image from the Docker Hub
FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install pytest

# Copy the rest of the application code into the container
COPY *.py .

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application, making port 5000 externally accessible
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
