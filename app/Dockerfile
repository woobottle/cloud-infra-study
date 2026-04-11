# ===========
# Stage 1: 환경 설정 &  의존성 설치
# ===========

ARG NODE_VERSION=24

# node.js 베이스 이미지 사용
FROM --platform=linux/amd64 node:${NODE_VERSION}-alpine AS base
WORKDIR /app
COPY package.json ./
RUN corepack enable && pnpm install

# ===========
# Stage 2: 애플리케이션 빌드
# ===========

FROM --platform=linux/amd64 node:${NODE_VERSION}-alpine AS builder
WORKDIR /app
COPY --from=base /app/node_modules ./node_modules
COPY . .
RUN corepack enable && pnpm run build

# ===========
# Stage 3: 프로덕션 이미지
# ===========
FROM --platform=linux/amd64 node:${NODE_VERSION}-alpine AS runner
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json ./package-lock.json

EXPOSE 3000

CMD ["npm", "run", "start"]


# 실제 실행 명령어
# docker build -t my-next-app .
# docker run -d -p 3000:3000 --name my-next-app my-next-app
# docker stop my-next-app && docker rm my-next-app