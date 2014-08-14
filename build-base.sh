#/bin/bash

# Remove old instances
docker ps -a | grep Exit | awk '{print $1}' | xargs docker rm
docker rmi devsoup/centos6-jdk7

cat > buildbase.dockerfile << EOF
# Set the base image
FROM centos:centos6

# Install OpenJDK
RUN yum install -y java-1.7.0-openjdk-devel
RUN echo export JAVA_HOME=/etc/alternatives/java_sdk > /etc/profile.d/java.sh

# Install Git
RUN yum install -y git

# Install Maven
RUN yum install -y wget
RUN wget http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
RUN yum install -y tar
RUN tar xzf apache-maven-3.1.1-bin.tar.gz -C /usr/local
WORKDIR /usr/local
RUN ln -s apache-maven-3.1.1 maven
WORKDIR /
RUN echo export M2_HOME=/usr/local/maven > /etc/profile.d/maven.sh
RUN echo export PATH=\\\${M2_HOME}/bin:\\\${PATH} >> /etc/profile.d/maven.sh
RUN echo source /etc/profile > ~/.profile

# Install unzip
RUN yum install -y unzip

# Install vim
RUN yum install -y vim

EOF

# Build it
docker build -t devsoup/centos6-jdk7 - < buildbase.dockerfile

echo Try 'docker run -it devsoup/centos6-jdk7 /bin/bash -l'
