# Stage 1: Build the application dependencies
FROM python:3.9-slim as builder

WORKDIR /app

# Install dependencies
COPY app/requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /app/wheels -r requirements.txt

# Stage 2: Create the final production image
FROM python:3.9-slim

WORKDIR /app

# Copy the dependencies from the builder stage
COPY --from=builder /app/wheels /app/wheels

# Install the dependencies from the local wheels
RUN pip install --no-index --find-links=/app/wheels /app/wheels/*

# Copy the application code
COPY app/ .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]