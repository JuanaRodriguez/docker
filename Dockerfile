FROM node:12

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./

# Install the dependencias
RUN npm install

# Copying rest of the application to app directory
COPY . .

# Expose the port and start the application
EXPOSE 3000

# Runner
CMD ["npm","start"]
