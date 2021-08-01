# docker course
Dockerize an image from node application

# Create image:
docker build -t appjs:1.0 .

# Create container:
docker run -d --name app -p 3000 appjs:1.0

# To execute:
docker logs -f app
