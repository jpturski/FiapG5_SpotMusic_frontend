FROM node:current-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --ignore-scripts

COPY public ./public
COPY src ./src

RUN npm run build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf.template


ARG EVENTS
ENV EVENTS=${EVENTS}
ARG PORT
ENV PORT=${PORT}
ARG REACT_APP_BACKEND_URL 
ENV REACT_APP_BACKEND_URL=${REACT_APP_BACKEND_URL}
RUN envsubst '${EVENTS},${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

COPY --from=builder /app/build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
