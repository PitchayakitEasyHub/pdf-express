FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install Node.js 18
RUN dnf install -y nodejs npm \
    # chromium-headless \
    libX11 \
    libXcomposite \
    libXdamage \
    libXext \
    libXfixes \
    libXi \
    libXrandr \
    libXrender \
    libXtst \
    libxcb \
    libxshmfence \
    mesa-libgbm \
    pango \
    alsa-lib \
    atk \
    at-spi2-atk \
    cups-libs \
    libdrm \
    dbus-libs \
    expat \
    fontconfig \
    freetype \
    gtk3 \
    nspr \
    nss \
    xdg-utils \
    wget

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install -g nodemon && \
    npm install
# Copy application code
COPY . .

# Update index.js puppeteer launch config
# Update puppeteer launch config with required args
RUN sed -i 's/headless: false/headless: true/' index.js && \
    sed -i 's|// executablePath|executablePath: "/usr/bin/chromium-browser"|' index.js && \
    sed -i 's/launch()/launch({args: ["--no-sandbox", "--disable-setuid-sandbox"]})/' index.js

# Expose port (adjust as needed)
EXPOSE 8080

# Start command
CMD ["node", "index.js"]