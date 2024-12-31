FROM ghcr.io/puppeteer/puppeteer:23.11.1

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json for dependencies
COPY package*.json ./

# Install backend dependencies
RUN npm ci

# Install additional dependencies required for Puppeteer

# Create the frontend directory and set permissions
RUN mkdir -p frontend && chown -R pptruser:pptruser frontend

# Switch to Puppeteer's default user
USER pptruser

# Copy the rest of the application code
COPY . .

# Switch to root for frontend dependency installation
USER root

RUN apk add --no-cache chromium

# Install frontend dependencies and build the frontend
RUN npm install --prefix frontend && npm run build --prefix frontend

# Switch back to Puppeteer's default user for running the app


# Start the backend server
CMD ["node", "backend/index.js"]

