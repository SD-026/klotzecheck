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
RUN mkdir -p frontend 

# Copy the rest of the application code
COPY . .

# Switch to root user for chown
USER root

# Set ownership of frontend files as root
RUN chown -R root:root /usr/src/app/frontend

# Switch to pptruser for further steps
USER pptruser

# Install frontend dependencies and build the frontend
RUN npm install --prefix frontend --unsafe-perm && npm run build --prefix frontend

# Start the backend server
CMD ["node", "backend/index.js"]
