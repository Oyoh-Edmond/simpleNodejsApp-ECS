FROM node:18.16.0-alpine3.17

WORKDIR /app

COPY package.json  .

RUN yarn

COPY . .

EXPOSE 3000

CMD [ "npm", "start"]