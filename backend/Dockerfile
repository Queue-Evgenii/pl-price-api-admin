FROM node:22.11-alpine AS builder

WORKDIR /app

COPY package*.json ./

COPY . .

RUN npm install --frozen-lockfile

RUN npm run build && npm run build auth && npm run build task

EXPOSE 3000

CMD ["node"]