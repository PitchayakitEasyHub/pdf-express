# Use Amazon Linux 2023 as base image
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install Node.js 18 and npm
RUN dnf update -y && \
    dnf install -y \
        nodejs \
        npm \
        chromium \
        chromium-headless \
        chromium-libs \
        nss \
        freetype \
        freetype-devel \
        fontconfig \
        ca-certificates \
        mesa-libgbm \
        libXcomposite \
        libXdamage \
        libXrandr \
        libxkbcommon \
        pango \
        alsa-lib \
        atk \
        at-spi2-atk \
        cups-libs \
        libdrm \
        libgbm && \
    dnf clean all

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install -g nodemon && \
    npm install

# Copy app source
COPY . .

# Expose port (adjust as needed)
EXPOSE 3000

# Start command
CMD ["node", "index.js"]
