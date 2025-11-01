# Use Node.js 24 as base image
FROM node:24-alpine AS base

# Install yarn
RUN corepack enable

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json yarn.lock .yarnrc.yml ./

# Install dependencies
RUN yarn install --frozen-lockfile --production=false

# Copy source code
COPY . .

# Build the application
RUN yarn build

# Production stage
FROM node:24-alpine AS production

# Install yarn
RUN corepack enable

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json yarn.lock .yarnrc.yml ./

# Install only production dependencies
RUN yarn install --frozen-lockfile --production

# Copy built application from base stage
COPY --from=base /app/dist ./dist

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S bot -u 1001

# Change ownership of the app directory
RUN chown -R bot:nodejs /app
USER bot

# Expose port (if needed for health checks)
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "process.exit(0)" || exit 1

# Start the bot
CMD ["node", "dist/index.js"]