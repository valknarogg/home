FROM directus/directus:latest

USER root
RUN corepack enable
USER node

RUN pnpm install @opentelemetry/api
RUN pnpm install @opentelemetry/auto-instrumentations-node