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
  procps \
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

# Install plugins
RUN curl -L -o ~/apache-jmeter/lib/ext/jmeter-plugins-manager.jar -O https://jmeter-plugins.org/get/ \
  && curl -L -o ~/apache-jmeter/lib/cmdrunner-2.0.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar \
  && java -cp ~/apache-jmeter/lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh available \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-graphs-basic \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-graphs-additional \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-autostop \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-sense \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install blazemeter-debugger \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-cmd \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-graphs-composite \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-csl \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-functions \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-casutg \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-dbmon \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-directory-listing \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-graphs-dist \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-dummy \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-filterresults \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-ffw \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-ggl \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-httpraw \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-sts \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-hadoop \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-fifo \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-jms \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-jmxmon \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-json \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-graphs-vs \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install kafkameter \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-lockfile \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-mergeresults \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-oauth \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-pde \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-prmctl \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-perfmon \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-redis \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-rotating-listener \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-webdriver \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-synthesis \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-plancheck \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-tst \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-udp \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-csvars \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-wsc \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-xml \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-xmpp \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-standard

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
