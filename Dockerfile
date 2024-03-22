ARG NODE_VERSION=${{ inputs.node-version }}

FROM node:${NODE_VERSION}



WORKDIR usr/src/app

COPY package*.json  .

RUN npm install

# RUN echo $VERSION > image_version

COPY . .

EXPOSE 3000

CMD [ "npm", "start"]