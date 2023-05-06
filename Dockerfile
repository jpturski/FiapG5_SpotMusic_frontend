FROM nginx:alpine

COPY package.json /app/package.json
WORKDIR /app
RUN apk add --no-cache nodejs npm
RUN npm install && npm cache clean --force

COPY public /app/public
COPY src /app/src
RUN npm run build

RUN mv /app/build /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf.template
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE $PORT

CMD ["/start.sh"]