FROM ubuntu:16.04

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

# SSH config.
RUN mkdir -p /root/.ssh
ADD config/ssh /root/.ssh/config
RUN chown root:root /root/.ssh/config && chmod 600 /root/.ssh/config

# Install base.
RUN apt-get update \
  && apt-get -y install \
  bash \
  build-essential \
  curl \
  jq \
  openssl \
  openssh-client \
  python \
  python-pip \
  python-wheel \
  procps \
  wget \
  && rm -rf /var/lib/apt/lists/* \
  && pip install yq requests

COPY --from=hairyhenderson/gomplate:v3.1.0-slim /gomplate /bin/gomplate

# Install goofys
ENV GOOFYS_VERSION 0.19.0
RUN curl --fail -sSL -o goofys https://github.com/kahing/goofys/releases/download/v${GOOFYS_VERSION}/goofys \
  && mv goofys /usr/local/bin/ \
  && chmod +x /usr/local/bin/goofys


# Install fd
ENV FD_VERSION 7.3.0
RUN curl --fail -sSL -o fd.tar.gz https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz \
  && tar -zxf fd.tar.gz \
  && cp fd-v${FD_VERSION}-x86_64-unknown-linux-gnu/fd /usr/local/bin/ \
  && rm -f fd.tar.gz \
  && rm -fR fd-v${FD_VERSION}-x86_64-unknown-linux-gnu \
  && chmod +x /usr/local/bin/fd

# Install variant
ENV VARIANT_VERSION 0.29.0
RUN curl --fail -sSL -o variant.tar.gz https://github.com/mumoshu/variant/releases/download/v${VARIANT_VERSION}/variant_${VARIANT_VERSION}_linux_amd64.tar.gz \
    && mkdir -p variant \
    && tar -zxf variant.tar.gz -C variant \
    && cp variant/variant /usr/local/bin/ \
    && rm -f variant.tar.gz \
    && rm -fR variant \
    && chmod +x /usr/local/bin/variant

# Install Taurus.
RUN apt-get update \
  && apt-get -y install \
  libxslt1.1 \
  libxslt1-dev \
  libxml2 \
  libxml2-dev \
  python-pip \
  && rm -rf /var/lib/apt/lists/* \
  && pip install bzt==1.13.7

# Install Java, jmeter.
ENV JAVA_HOME /usr
RUN apt-get update \
  && apt-get -y install openjdk-8-jre-headless maven \
  && rm -rf /var/lib/apt/lists/*

# Install jMeter.
ENV JMETER_VERSION 5.1.1
ENV JMETER_HOME=/apache-jmeter
RUN curl -o /apache-jmeter.tgz https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
  && tar -C / -xzf /apache-jmeter.tgz \
  && rm /apache-jmeter.tgz \
  && mv /apache-jmeter-${JMETER_VERSION} ${JMETER_HOME} \
  && rm ${JMETER_HOME}/bin/user.properties

COPY user.properties ${JMETER_HOME}/bin/

# Install plugins.
RUN curl -L -o ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar -O https://jmeter-plugins.org/get/ \
  && curl -L -o ${JMETER_HOME}/lib/cmdrunner-2.2.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
  && java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  && ${JMETER_HOME}/bin/PluginsManagerCMD.sh available \
  && ${JMETER_HOME}/bin/PluginsManagerCMD.sh install-all-except

ENTRYPOINT ["bzt"]

