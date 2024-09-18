FROM node:20.17.0

ENV NODE_ENV=development

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
