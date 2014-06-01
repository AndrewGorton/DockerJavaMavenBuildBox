#/bin/bash

# Remove old instances
docker rm `docker ps --no-trunc -a -q`
docker rmi devsoup/simple-builder

cat > buildbuilder.dockerfile << EOF
# Set the base image
FROM devsoup/centos-jdk7

# Download the code to build
WORKDIR /var
RUN mkdir tmpbuild
WORKDIR /var/tmpbuild
RUN wget https://github.com/devsoup/SimpleDropWizardEcho/archive/develop.zip
RUN unzip develop.zip

# Build it
WORKDIR /var/tmpbuild/SimpleDropWizardEcho-develop
RUN /bin/bash -l mvn package

EOF

# Build it
docker build -t devsoup/simple-builder - < buildbuilder.dockerfile

echo Try 'docker run -i -t -p 49000:8080 -p 49000:8081 devsoup/simple-builder java -jar /var/tmpbuild/SimpleDropWizardEcho-develop/target/SimpleDropWizardEcho-1.0-SNAPSHOT.jar server'
