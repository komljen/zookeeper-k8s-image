#!/usr/bin/env bash
#===============================================================================
#
#===============================================================================
config="${APP_ROOT}/conf/zoo.cfg"

ID="${HOSTNAME#*-}"
DOMAIN=$(hostname -d)
echo $((ID + 1)) >"${DATA_DIR}/myid"

cat >"$config" <<EOF
tickTime=2000
initLimit=10
syncLimit=2000
minSessionTimeout=4000
maxSessionTimeout=40000
dataDir=${DATA_DIR}
clientPort=2181
maxClientCnxns=100
autopurge.snapRetainCount=3
autopurge.purgeInterval=0
EOF

if [[ $ZOOKEEPER_SERVERS -gt 1 ]]; then
  for ((i = 1; i <= $ZOOKEEPER_SERVERS; i++)); do
    echo "server.${i}=zookeeper-$((i - 1)).${DOMAIN}:2888:3888" >>"$config"
  done
fi

if [[ $JMX_ENABLED == true ]]; then
  JVMFLAGS="$JVMFLAGS -Dcom.sun.management.jmxremote.port=${JMX_PORT:-3000}"
  JVMFLAGS="$JVMFLAGS -Dcom.sun.management.jmxremote.authenticate=false"
  JVMFLAGS="$JVMFLAGS -Dcom.sun.management.jmxremote.ssl=false"
  export JVMFLAGS
fi

exec "${APP_ROOT}/bin/zkServer.sh" start-foreground
#===============================================================================
