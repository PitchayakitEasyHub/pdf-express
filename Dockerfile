FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install Node.js 18 and Chrome dependencies
RUN dnf install -y nodejs npm sudo yum

# Install Chrome using Google's official repo
# RUN curl -o /tmp/chrome.rpm https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
#     dnf install -y /tmp/chrome.rpm && \
#     rm /tmp/chrome.rpm
RUN sudo yum install -y libXcomposite libXdamage libXrandr libgbm libxkbcommon pango alsa-lib atk at-spi2-atk cups-libs libdrm nss libXScrnSaver

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install -g nodemon && \
    npm install
# Copy application code
COPY . .

# Expose port (adjust as needed)
EXPOSE 3000

# Start command
CMD ["node", "index.js"]