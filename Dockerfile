From ghcr.io/puppeteer/puppeteer:23.11.1 
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false \
PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci 
COPY ..
CMD ["npm install && npm install --prefix frontend && npm run build --prefix frontend",]
CMD ["nodemon" ,"backend/index.js"]