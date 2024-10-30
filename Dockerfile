FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install Node.js 18
RUN dnf install -y nodejs npm

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