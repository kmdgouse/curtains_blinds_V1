# Use official Node.js LTS image (Node 20 recommended for Next.js 13+)
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm install --frozen-lockfile || npm install

# Copy rest of the app
COPY . .

# Build the app
RUN npm run build

# -----------------------
# Production stage
# -----------------------
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only what's needed to run
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Expose port (Coolify maps this)
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
