# ===== build stage =====
FROM node:22-alpine AS builder

WORKDIR /app

# 👇 关键：编译环境
RUN apk add --no-cache python3 make g++

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# ===== runtime stage =====
FROM node:22-alpine

WORKDIR /app

COPY --from=builder /app/.output .output
COPY --from=builder /app/package*.json ./

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]