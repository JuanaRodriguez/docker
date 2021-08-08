FROM node:12-alpine as build_appjs
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD ["npm","start"]

FROM node:12-alpine 
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY --from=build_appjs . /app
EXPOSE 3000
CMD ["npm","start"]
