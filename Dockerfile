FROM node:current-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --ignore-scripts

COPY public ./public
COPY src ./src

RUN npm run build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf.template


ARG EVENTS=1024
ARG PORT=8080
RUN envsubst '${EVENTS},${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE $PORT

CMD ["nginx", "-g", "daemon off;"]