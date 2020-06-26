# springboot-gradle6-centos
#
# This image provide a base for running Spring Boot based applications. It
# provides a base Java 8 installation and Gradle 6.

FROM openshift/base-centos7

EXPOSE 8080

ENV JAVA_VERSON 1.8.0
ENV GRADLE_VERSION 6.5

LABEL architecture="x86_64" \
      io.k8s.description="Platform for building and running Spring Boot applications" \
      io.k8s.display-name="Spring Boot Gradle 6" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,java8,gradle,gradle6,springboot" \
      io.openshift.s2i.destination="/tmp" 

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all

RUN curl -fsSL https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip -o /tmp/gradle-$GRADLE_VERSION-bin.zip && \
    unzip /tmp/gradle-$GRADLE_VERSION-bin.zip -d /usr/share/ && \
    rm /tmp/gradle-$GRADLE_VERSION-bin.zip && \
    mv /usr/share/gradle-$GRADLE_VERSION /usr/share/gradle && \
    ln -s /usr/share/gradle/bin/gradle /usr/bin/gradle

ENV JAVA_HOME /usr/lib/jvm/java
ENV GRADLE_HOME /usr/share/gradle

# Add configuration files, bashrc and other tweaks
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

USER root

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage