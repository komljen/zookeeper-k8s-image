FROM openjdk:8
LABEL maintainer="Alen Komljen <akomljen.com>"

ENV APP_ROOT=/opt/zookeeper
ENV DATA_DIR=/data/zookeeper
ENV JMX_ENABLED=false

ENV ZOOKEEPER_VERSION 3.4.10
ENV ZOOKEEPER_URL https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz

RUN \
  apt-get update && \
  apt-get -y install netcat && \
  curl -fSL "$ZOOKEEPER_URL" -o /tmp/zookeeper.tar.gz && \
  tar -xvf /tmp/zookeeper.tar.gz -C /opt && \
  mv ${APP_ROOT}-${ZOOKEEPER_VERSION} ${APP_ROOT} && \
  rm /tmp/zookeeper.tar.gz && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p "$DATA_DIR"
VOLUME "$DATA_DIR"

COPY zkOK.sh "${APP_ROOT}/bin/zkOK.sh"
COPY start.sh /start.sh
RUN chmod a+x /start.sh "${APP_ROOT}/bin/zkOK.sh"

EXPOSE 2181 2888 3888

CMD ["/start.sh"]
