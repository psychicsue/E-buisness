# Environment
FROM ubuntu

RUN apt-get update
RUN apt-get install -y wget git
RUN apt-get install curl

# Define environment variables
ENV LOCAL /usr/local/bin
ENV SCALA_HOME $LOCAL/scala
ENV JAVA_HOME $LOCAL/java
ENV SBT_VERSION 1.1.1
ENV PATH=$SCALA_HOME/bin:$JAVA_HOME/bin:$PATH

RUN mkdir /app
WORKDIR /app

# Move over JDK, Scala
ADD scala-2.13.0-M3.tgz /app
ADD jdk-8u161-linux-x64.tar.gz /app

# Get JDK and Scala into place
RUN mv jdk1.8.0_161 $JAVA_HOME
RUN mv scala-2.13.0-M3 $SCALA_HOME

RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

# Scala expects this file
RUN touch $JAVA_HOME/release

RUN apt-get update
RUN apt-get install -v scala

COPY ./build.sbt ./
RUN sbt -v update

EXPOSE 80 8888

CMD sbt console