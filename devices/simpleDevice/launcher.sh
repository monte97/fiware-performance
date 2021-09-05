#!/bin/bash

NUM=$1
STATUS=$2
TIME=$3
EXP_NAME=$4
HOW_MANY=$5
HOW_OFTEN=$6
STEP=$7
PAYLOAD_KB=$8

FIWARE_HOST="137.204.74.59"
IOTA_PORT="4041"

echo ${FIWARE_HOST}
echo ${IOTA_PORT}

curl \
    --max-time 10 \
    --connect-timeout 2 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
  -iX POST \
  "http:/${FIWARE_HOST}:${IOTA_PORT}/iot/devices" \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -d '{
  "devices": [
    {
      "device_id":   "'"device$NUM"'",
      "entity_name": "'"urn:ngsi-ld:device:$NUM"'",
      "entity_type": "Device",
      "transport": "MQTT",
      "commands": [
        { "name": "on", "type": "command" },
        { "name": "off", "type": "command" }
       ],
      "attributes": [
        { "object_id": "s", "name": "Status", "type": "Boolean" },
        { "object_id": "time", "name": "Time", "type": "Integer" },
        { "object_id": "p", "name": "Payload", "type": "String" }
     ]
    }
  ]
}' &>/dev/null &

echo "post post"
echo $(pwd)
#pass NUM to docker as env variable
docker run \
  --env ID=${NUM} \
  --env STATUS=${STATUS} \
  --env TIME=${TIME} \
  --env EXP_NAME=${EXP_NAME} \
  --env HOW_MANY=${HOW_MANY} \
  --env HOW_OFTEN=${HOW_OFTEN} \
  --env STEP=${STEP} \
  --env PAYLOAD_KB=${PAYLOAD_KB} \
  --name term${NUM} \
  -v ~/demoweb2_performance_websplit/devices/thermometerMQTT3-remoteVersion/mylogs:/tmp/test/mylogs \
  monte/term