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
  && apt-get -y install openjdk-8-jre-headless maven \
  && rm -rf /var/lib/apt/lists/*

# Install JMeter.
ENV JMETER_VERSION 3.3
RUN curl -o ~/apache-jmeter.tgz http://apache.volia.net/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
  && tar -C ~ -xzf ~/apache-jmeter.tgz \
  && rm ~/apache-jmeter.tgz \
  && mv ~/apache-jmeter-${JMETER_VERSION} ~/apache-jmeter

# Install plugins
RUN curl -L -o ~/apache-jmeter/lib/ext/jmeter-plugins-manager.jar -O https://jmeter-plugins.org/get/ \
  && curl -L -o ~/apache-jmeter/lib/cmdrunner-2.0.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar \
  && curl -L -o ~/apache-jmeter/lib/xstream-1.4.10.jar http://search.maven.org/remotecontent?filepath=com/thoughtworks/xstream/xstream/1.4.10/xstream-1.4.10.jar \
  && java -cp ~/apache-jmeter/lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh available \
  && ~/apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-graphs-basic,jpgc-graphs-additional,jpgc-autostop,jpgc-sense,blazemeter-debugger,jpgc-cmd,jpgc-graphs-composite,jpgc-csl,jpgc-functions,jpgc-casutg,jpgc-dbmon,jpgc-directory-listing,jpgc-graphs-dist,jpgc-dummy,jpgc-filterresults,jpgc-ffw,jpgc-ggl,jpgc-httpraw,jpgc-sts,jpgc-hadoop,jpgc-fifo,jpgc-jms,jpgc-jmxmon,jpgc-json,jpgc-graphs-vs,kafkameter,jpgc-lockfile,jpgc-mergeresults,jpgc-oauth,jpgc-pde,jpgc-prmctl,jpgc-perfmon,jpgc-redis,jpgc-rotating-listener,jpgc-synthesis,jpgc-plancheck,jpgc-tst,jpgc-udp,jpgc-csvars,jpgc-wsc,jpgc-xml,jpgc-xmpp,jpgc-standard,netflix-cassandra,custom-soap,elasticsearch-backend-listener,bzm-hls,bzm-http2,mqtt-sampler,bzm-parallel,ssh-sampler,tilln-sshmon,tilln-wssecurity,websocket-sampler,websocket-samplers

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
