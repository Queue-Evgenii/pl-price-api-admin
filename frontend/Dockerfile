FROM node:22.11-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install -g npm@11 \
 && npm cache clean --force \
 && npm ci --no-audit --no-fund

COPY . .

RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]