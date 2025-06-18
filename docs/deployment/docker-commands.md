### Commands to build and run docker image
sudo docker build --no-cache -t sf-crime-stats-mage . 

sudo docker run -it --rm \
  -p 6789:6789 \
  -e PROJECT_NAME=sf-crime-stats \
  sf-crime-stats-mage

### Commands to tag and deploy docker image to Docker Hub
docker tag sf-crime-stats-mage kdayno/sf-crime-stats:latest
docker login
docker push kdayno/sf-crime-stats:latest