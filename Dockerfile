# Multi-stage build for B1Transfer Vite/React application
FROM node:22-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./
RUN npm ci

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build arguments for environment-specific builds
ARG BUILD_ENV=production
ENV NODE_ENV=production

# Copy the appropriate environment file and remove all others
# so Vite (with NODE_ENV=production) doesn't load .env.production on top
RUN if [ "$BUILD_ENV" = "demo" ]; then \
      cp .env.demo .env; \
    elif [ "$BUILD_ENV" = "staging" ]; then \
      cp .env.staging .env; \
    else \
      cp .env.production .env; \
    fi && \
    rm -f .env.demo .env.staging .env.production .env.sample .env.local .env.*.local

# Build Vite application
RUN npm run build

# Production image - serve with nginx
FROM nginx:alpine AS runner
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy built assets from builder
COPY --from=builder /app/build .

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
