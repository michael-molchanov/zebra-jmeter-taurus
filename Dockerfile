FROM ubuntu:16.04

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

# Install base.
RUN apt-get update \
  && apt-get -y install \
  bash \
  build-essential \
  curl \
  openssl \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Install Java.
ENV JAVA_HOME /usr
RUN apt-get update \
  && apt-get -y install openjdk-8-jre-headless \
  && rm -rf /var/lib/apt/lists/*

# Install JMeter.
ENV JMETER_VERSION 3.2
RUN curl -o ~/apache-jmeter.tgz http://apache.volia.net/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
  && tar -C ~ -xzf ~/apache-jmeter.tgz \
  && rm ~/apache-jmeter.tgz \
  && mv ~/apache-jmeter-${JMETER_VERSION} ~/apache-jmeter

# Install Taurus.
RUN apt-get update \
  && apt-get -y install \
  libxslt1.1 \
  libxslt1-dev \
  libxml2 \
  libxml2-dev \
  python-pip \
  && rm -rf /var/lib/apt/lists/* \
  && pip install bzt

ENTRYPOINT ["bzt"]
