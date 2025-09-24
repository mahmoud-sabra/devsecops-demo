# -------- Stage 1: Build the app --------
FROM node:20-alpine as builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy app source code
COPY . .

# -------- Stage 2: Create minimal image using distroless --------
FROM gcr.io/distroless/nodejs20-debian11

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app .

# Expose application port
EXPOSE 3000

# Run the Node.js app
CMD ["app.js"]
