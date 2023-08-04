FROM node:20-alpine

WORKDIR /app

COPY package-lock.json /app/package-lock.json
COPY package.json /app/package.json
RUN npm install

COPY . /app

RUN npm run build

EXPOSE 5125-5158
VOLUME [ "/app/banlist.txt" ]

CMD ["./start.sh"]