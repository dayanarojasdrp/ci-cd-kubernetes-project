# Stage 1: install production dependencies
FROM node:18-alpine AS dependencies

WORKDIR /app

COPY app/package*.json ./

RUN npm ci --omit=dev


# Stage 2: production runtime
FROM node:18-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV APP_NAME=ci-cd-kubernetes-app
ENV APP_VERSION=1.0.0
ENV APP_ENV=production

COPY --from=dependencies /app/node_modules ./node_modules
COPY app/src ./src
COPY app/package*.json ./

EXPOSE 3000

USER node

CMD ["npm", "start"]
