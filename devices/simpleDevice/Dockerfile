from node:16

curr_uid=`id -u`
curr_gid=`id -g`

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .
COPY ./../../.env .

EXPOSE 8080

ENV NODE_OPTIONS=--max_old_space_size=60000

CMD ["node", "server.js"]

RUN usermod -u ${curr_uid} node
USER node
