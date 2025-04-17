FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    unzip \
    git \
    libglib2.0-0 \
    libnss3 \
    libgconf-2-4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libxss1 \
    libasound2 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm-dev \
    libxshmfence-dev \
    fonts-liberation \
    libappindicator1 \
    libappindicator3-1 \
    xdg-utils \
    ca-certificates \
    && apt-get clean

# Set work directory
WORKDIR /app

# Copy your requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers
RUN apt-get install -y wget && \
    wget https://playwright.azureedge.net/builds/playwright/rust/playwright-rust-linux-x64.tar.gz && \
    pip install playwright && \
    playwright install --with-deps


# Copy the rest of your code
COPY . .

# Expose the port if you're running an API
EXPOSE 8000

# Default command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
