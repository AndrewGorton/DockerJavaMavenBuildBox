#/bin/bash

# Remove old instances
docker rm `docker ps --no-trunc -a -q`
docker rmi devsoup/ubuntu-jdk7

cat > buildbase.dockerfile << EOF
# Set the base image
FROM ubuntu:latest

# Install OpenJDK
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk
RUN echo export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 > /etc/profile.d/java.sh

# Install Git
RUN apt-get install -y git

# Install Maven
RUN apt-get install -y wget
RUN wget http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
RUN apt-get install -y tar
RUN tar xzf apache-maven-3.1.1-bin.tar.gz -C /usr/local
WORKDIR /usr/local
RUN ln -s apache-maven-3.1.1 maven
WORKDIR /
RUN echo export M2_HOME=/usr/local/maven > /etc/profile.d/maven.sh
RUN echo export PATH=\\\${M2_HOME}/bin:\\\${PATH} >> /etc/profile.d/maven.sh
RUN echo source /etc/profile > ~/.profile

# Install unzip
RUN apt-get install -y unzip

# Install vim
RUN apt-get install -y vim

EOF

# Build it
docker build -t devsoup/ubuntu-jdk7 - < buildbase.dockerfile

echo Try 'docker run -it devsoup/ubuntu-jdk7 /bin/bash -l'
