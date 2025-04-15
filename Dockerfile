# Use slim Python base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Non-interactive to avoid prompts
ARG DEBIAN_FRONTEND=noninteractive

# Install Playwright dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    fonts-liberation \
    libnss3 \
    libnspr4 \
    libdbus-1-3 \
    libxkbcommon0 \
    libasound2 \
    libjpeg-dev \
    libxshmfence1 \
    libxcomposite1 \
    libxrandr2 \
    libxdamage1 \
    libxfixes3 \
    libxext6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers (chromium)
RUN playwright install chromium

# Copy the full project
COPY . .

# For Render or other dynamic port environments
ENV PORT 8000
EXPOSE 8000

# Start FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
