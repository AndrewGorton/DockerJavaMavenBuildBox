# DockerJavaMavenBuildBox

## Description

Example of using [Docker](http://docker.io) as a build container. 

This has two parts. The first part creates a container with OpenJDK-7-JDK, Maven and Git installed. The second part is an app-specific build box which compiles a simple DropWizard service into a container, and which runs the service when the container is started.


## The generic build container

### Building

```bash
./build-base.sh
```

### Running

```bash
docker run -it devsoup/ubuntu-jdk7 /bin/bash -l
```

## The app-specific container

### Building

You must build the build container first!

```bash
./build-builder.sh
```

### Running

```bash
docker run -i -t -p 49000:8080 -p 49001:8081 devsoup/simple-builder
```

Because I’m on a Mac, this redirects port 49000 and 49001 locally to 8080 and 8081 on the docker-vm. Once it runs, it should say suggest something like “curl -i http://192.168.59.103:49000/echo?echo=amazing” to test the service in the container.


