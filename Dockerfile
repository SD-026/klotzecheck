FROM ghcr.io/puppeteer/puppeteer:23.11.1 

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json for dependencies
COPY package*.json ./

# Install backend dependencies
RUN npm ci

# Copy the rest of the application code to the container
COPY . .

# Install frontend dependencies and build the frontend
RUN npm install --prefix frontend && npm run build --prefix frontend

# Start the backend server
CMD ["nodemon", "backend/index.js"]
