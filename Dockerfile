FROM node:latest AS build

WORKDIR /app

COPY ./package.json /app/package.json

RUN yarn install
COPY . .
RUN npm run build

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf.template
COPY --from=build /app/build /usr/share/nginx/html
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE $PORT

CMD ["/start.sh"]