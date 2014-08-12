#/bin/bash

# Remove old instances
docker rm `docker ps --no-trunc -a -q`
docker rmi devsoup/simple-builder

cat > buildbuilder.dockerfile << EOF
# Set the base image
FROM devsoup/ubuntu-jdk7

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
docker build -t devsoup/simple-builder - < buildbuilder.dockerfile

echo Try 'docker run -i -t -p 49000:8080 -p 49001:8081 devsoup/simple-builder'
echo Then "curl -i http://$(/usr/local/bin/boot2docker ip 2>/dev/null):49000/echo?echo=amazing && echo"
