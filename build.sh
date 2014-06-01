#/bin/bash

# Remove old instances
docker rm `docker ps --no-trunc -a -q`
docker rmi devsoup/centos-jdk7

cat > build.dockerfile << EOF
# Set the base image
FROM centos

# Install OpenJDK
RUN yum -y install java-1.7.0-openjdk-devel
RUN echo export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64 > /etc/profile.d/java.sh

# Install Git
RUN yum -y install git

# Install Maven
RUN yum -y install wget
RUN wget http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
RUN yum -y install tar
RUN tar xzf apache-maven-3.1.1-bin.tar.gz -C /usr/local
WORKDIR /usr/local
RUN ln -s apache-maven-3.1.1 maven
WORKDIR /
RUN echo export M2_HOME=/usr/local/maven > /etc/profile.d/maven.sh
RUN echo export PATH=\\\${M2_HOME}/bin:\\\${PATH} >> /etc/profile.d/maven.sh
RUN echo source /etc/profile > ~/.profile

EOF

# Build it
docker build -t devsoup/centos-jdk7 - < build.dockerfile

echo Try 'docker run -i -t devsoup/centos-jdk7 /bin/bash -l'