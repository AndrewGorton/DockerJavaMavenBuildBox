#/bin/bash

CONTAINER_NAME=devsoup/centos6-simpledropwizard

# Remove old instances
docker ps -a | grep Exit | awk '{print $1}' | xargs docker rm
docker rmi $CONTAINER_NAME

cat > buildbuilder.dockerfile << EOF
# Set the base image
FROM devsoup/centos6-jdk7

# Download the code to build
WORKDIR /var
RUN mkdir tmpbuild
WORKDIR /var/tmpbuild
RUN wget https://github.com/AndrewGorton/SimpleDropWizardEcho/archive/v1.0.1.zip
RUN unzip v1.0.1.zip

# Build it
WORKDIR /var/tmpbuild/SimpleDropWizardEcho-1.0.1
RUN /bin/bash -l mvn package

# Set the entry point
CMD ["java", "-jar", "/var/tmpbuild/SimpleDropWizardEcho-1.0.1/target/SimpleDropWizardEcho-1.0.1.jar", "server"]

EOF

# Build it
docker build -t $CONTAINER_NAME - < buildbuilder.dockerfile

echo Try "docker run -i -t -p 49000:8080 -p 49001:8081 $CONTAINER_NAME"
echo Then "curl -i http://$(/usr/local/bin/boot2docker ip 2>/dev/null):49000/echo?echo=amazing && echo"
