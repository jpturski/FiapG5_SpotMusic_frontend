FROM node:current-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --ignore-scripts


COPY public ./public
COPY src ./src


RUN npm run build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
COPY --from=builder /app/build /usr/share/nginx/html

RUN chmod +x /start.sh


CMD ["/start.sh"]