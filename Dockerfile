FROM ghcr.io/puppeteer/puppeteer:23.11.1 

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json for dependencies
COPY package*.json ./

# Install backend dependencies
RUN npm ci

# Ensure backend/output directory exists and has proper permissions
RUN mkdir -p /usr/src/app/backend/output && chown -R pptruser:pptruser /usr/src/app/backend/output

# Create the frontend directory and set permissions
RUN mkdir -p frontend && chown -R pptruser:pptruser frontend

# Copy the rest of the application code
COPY . .

# Install frontend dependencies and build the frontend
RUN npm install --prefix frontend && npm run build --prefix frontend

# Switch to root user for backend server
USER root

# Start the backend server
CMD ["node", "backend/index.js"]
