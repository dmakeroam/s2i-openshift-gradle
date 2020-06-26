# Spring Boot - Gradle 6 - CentOS Docker image

This repository contains the sources and [Dockerfile](https://github.com/dmakeroam/s2i-openshift-gradle/blob/master/Dockerfile) of the base image for deploying Spring Boot applications as reproducible Docker images. The resulting images can be run either by [Docker](http://docker.io) or using [S2I](https://github.com/openshift/source-to-image).

This image is heavily inspired by the awesome [openshift/sti-ruby](https://github.com/openshift/sti-ruby/) builder images.

## Usage

To build a simple springboot-sample-app application using standalone S2I and then run the resulting image with Docker execute:

```
$ s2i build git://github.com/codecentric/springboot-sample-app dmakeroam/s2i-openshift-gradle springboot-sample-app
$ docker run -p 8080:8080 springboot-sample-app
```

**Accessing the application:**

```
$ curl 127.0.0.1:8080
```

## Repository organization

* **`s2i/bin/`**

  This folder contains scripts that are run by [S2I](https://github.com/openshift/source-to-image):

  *   **assemble**

      Is used to restore the build artifacts from the previous built (in case of
      'incremental build'), to install the sources into location from where the
      application will be run and prepare the application for deployment (eg.
      using gradle to build the application etc..)

  *   **run**

      This script is responsible for running a Spring Boot fat jar using `java -jar`.
      The image exposes port 8080, so it expects application to listen on port
      8080 for incoming request.

  *   **save-artifacts**

      In order to do an *incremental build* (iow. re-use the build artifacts
      from an already built image in a new image), this script is responsible for
      archiving those. In this image, this script will archive the
      `/opt/java/.gradle` directory.

## Environment variables

*  **APP_ROOT** (default: '.')

    This variable specifies a relative location to your application inside the
    application GIT repository. In case your application is located in a
    sub-folder, you can set this variable to a *./myapplication*.

*  **APP_TARGET** (default: 'target')

    This variable specifies a relative location to your application binary inside the
    container.

*  **GRADLE_ARGS** (default: '')

    This variable specifies the arguments for Gradle inside the container.

## Copyright

Released under the Apache License 2.0. See the [LICENSE](https://github.com/dmakeroam/s2i-openshift-gradle/blob/master/LICENSE) file.
