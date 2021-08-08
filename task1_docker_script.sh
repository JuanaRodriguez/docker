#!/bin/bash

###########################################################################################
# Script that create 5 docker containers in a network called homeworknet by JuanaRodriguez
###########################################################################################

# create network:
$ docker network create homeworknet

###############################   POSTGRES   ##############################################
# create the postgres volume:
$ docker volume create postgres_volume

# pull the postgres image:
$ docker pull postgres:latest

# run postgres with custom config
docker run -d -it --name postgresdb \
	-v postgres_volume:/var/lib/postgresql/data \
	-e POSTGRES_USER=sonar \
	-e POSTGRES_PASSWORD=sonaradmin \
	--network homeworknet postgres:latest

###############################   SONARQUBE   ##############################################
# create the volumes with the following commands:
docker volume create sonarqube_data_volume
docker volume create sonarqube_logs_volume
docker volume create sonarqube_extensions_volume

# pull the sonarqube image:
docker pull sonarqube

# for Linux set the recommended values for the current session by running the following commands as root on the host:
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -w fs.file-max=131072

# run the image with your database properties defined using the -e environment variable flag: 
docker run -d -it --name sonarqubetool \
-e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 \
-e SONAR_JDBC_URL=jdbc:postgresql://localhost/sonarqube?currentSchema=my_schema \
-e SONAR_JDBC_USERNAME=sonar \
-e SONAR_JDBC_PASSWORD=sonaradmin \
-v sonarqube_data_volume:/opt/sonarqube/data \
-v sonarqube_extensions_volume:/opt/sonarqube/extensions \
-v sonarqube_logs_volume:/opt/sonarqube/logs \
--network homeworknet sonarqube:latest

############################### Jenkins ###############################
# create the jenkins volume:
docker volume create jenkins_volume

# pull the jenkins image:
docker pull jenkins/jenkins

# run the Jenkins image
docker run -d -it --name jenkinscicd \
	-v jenkins_volume:/var/jenkins_home \
	-p 8080:8080 -p 50000:50000 \
	--network homeworknet jenkins/jenkins

############################### Sonatype Nexus 3 ###############################
# create the Sonatype Nexus 3 volume:
docker volume sonatype_volume

# pull the Sonatype Nexus 3 image:
docker pull sonatype/nexus3

# run the Sonatype Nexus 3 image image:
docker run -d -it --name sonartyperepository \
	-p 8081:8081 \
	-v sonartype_volume:/nexus-data \
	--network homeworknet sonatype/nexus3

############################### Portainer ############################### 
# create the Portainer volume:
docker volume create portainer_volume

# pull the Portainer image:
docker pull portainer/portainer

# portainer Server Deployment:
docker run -d --name=portainerui \
	-p 8000:8000 -p 7000:7000 \
	--restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v portainer_volume:/data \
	--network homeworknet portainer/portainer-ce

# portainer Agent Only Deployment:
docker run -d --name portainer_agent \
	-p 7001:7001 \
	--restart=always \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /var/lib/docker/volumes:/var/lib/docker/volumes \
	--network homeworknet portainer/agent