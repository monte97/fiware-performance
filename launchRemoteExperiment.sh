#!/bin/bash
if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi
if [ -f kafka-docker/.env ]; then
  export $(echo $(cat kafka-docker/.env | sed 's/#.*//g'| xargs) | envsubst)
fi


NUM_DEVICE=$1
DEVICE_TIME=$2
SUB_NUM=$3
HOW_MANY_MESSAGES=$4
HOW_OFTEN_SPEEDUP=$5
SPEEDUP=$6
PAYLOAD_KB=$7

EXP_NAME=${NUM_DEVICE}_${DEVICE_TIME}_${HOW_MANY_MESSAGES}_${SUB_NUM}_${HOW_OFTEN_SPEEDUP}_${SPEEDUP}_${PAYLOAD_KB}_`date +"%G%m%d_%H%M"`
echo ${EXP_NAME}

#avviare fiware
echo "setup fiware on ${FIWARE_IP}"
ssh fmontelli@${FIWARE_IP}  docker-compose -f ${ROOT}/${CODE_FOLDER}/docker-compose-fiware.yml up --build &>/dev/null &
echo "wait for seutp completion"
./supportScripts/wait-for-it.sh ${FIWARE_IP}:${ZOOKEEPER_EXT_PORT} --timeout=480 -- echo "zookeeper is up"
./supportScripts/wait-for-it.sh ${FIWARE_IP}:${KAFKA_EXT_PORT} --timeout=480 -- echo "kafka is up"
./supportScripts/wait-for-it.sh ${FIWARE_IP}:${MOSQUITTO_PORT_EXT} --timeout=480 -- echo "mosquitto is up"
./supportScripts/wait-for-it.sh ${FIWARE_IP}:${ORION_PORT_EXT} --timeout=480 -- echo "orion is up"
./supportScripts/wait-for-it.sh ${FIWARE_IP}:${IOTA_NORTH_PORT} --timeout=480 -- echo "iota is up"
echo "setup fiware on ${FIWARE_IP} complete"

echo "setup draco on ${DRACO_IP}"
echo "wait for completion"
ssh fmontelli@${DRACO_IP} chmod -R 777 ${ROOT}/${CODE_FOLDER}/draco/nifi_volume
ssh fmontelli@${DRACO_IP} docker-compose -f ${ROOT}/${CODE_FOLDER}/docker-compose-draco.yml up --build &>/dev/null &
./supportScripts/wait-for-it.sh ${DRACO_IP}:${DRACO_API_PORT} --timeout=480 -- echo "draco is up"
echo "setup draco on ${DRACO_IP} complete"


echo "setup subscriptions"
#una sottoscrizione viene già creata dallo script di setup
echo "Begin create subscriptions"
for ((i=0; i<${SUB_NUM}; i++))
do
  echo "sub ${i}"
  curl -iX POST \
    --url 'http://${FIWARE_UP}:${ORION_PORT_EXT}/v2/subscriptions' \
    --header 'Content-Type: application/json' \
    --header 'fiware-service: openiot' \
    --header 'fiware-servicepath: /' \
    --data '{
    "description": "Notify me when any Thermometer changes state",
    "subject": {
    "entities": [{"idPattern": ".*","type": "Device"}],
    "condition": {
      "attrs": ["Status", "Payload", "Timestamp"]
    }
    },
    "notification": {
    "http": {
      "url": "http://${DRACO_IP}:${DRACO_WS_PORT}/v2/notify"
    },
    "attrsFormat" : "keyValues"
    }
  }' &>/dev/null
done
echo "Finish subscriptions creation"

echo "launch remote device on ${DEVICE_IP}"
ssh fmontelli@${DEVICE_IP} ${ROOT}/${CODE_FOLDER}/supportScripts/createDevices.sh ${START_58} ${NUM_58} ${TERM_TIME} ${SUB_NUM} ${HOW_MANY_MESSAGES} ${HOW_OFTEN_SPEEDUP} ${SPEEDUP} ${PAYLOAD_KB} ${EXP_NAME} $>/dev/null &
echo "wait launch on ${DEVICE_IP} completion"
count_device=$(($(ssh fmontelli@${DEVICE_IP} "docker ps | wc -l")-1))
while [ "${count_device}" != "${NUM_DEIVICE}" ]
do
  count_device=$(($(ssh fmontelli@${DEVICE_IP} "docker ps | wc -l")-1))
  sleep 10s
done
echo "launch on ${DEVICE_IP} complete"

echo "turn on all the devices"
#dare on  a tutti i device, on deve essere mandato ad OCB
for ((i=0; i<${NUM_DEVICE}; i++))
do
  echo ${i}
  curl \
    --max-time 10 \
    --connect-timeout 2 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -iX PATCH \
    --url "http://${FIWARE_IP}:${ORION_PORT_EXT}/v2/entities/urn:ngsi-ld:device:${i}/attrs" \
    --header 'Content-Type: application/json' \
    --header 'fiware-service: openiot' \
    --header 'fiware-servicepath: /' \
    --data '{
      "on": {
        "type": "command",
        "value": ""
      }
  }' &
done

echo "wait completion"
count_device=$(($(ssh fmontelli@${DEVICE_IP} "docker ps | wc -l")-1))
while [ "${count_58}" != "0" ]
do
  count_device=$(($(ssh fmontelli@${DEVICE_IP} "docker ps | wc -l")-1))
  sleep 10s
done
echo "completed"

echo "wait before stop"
sleep 10m


./supportScript/stopAll.sh


if false
then
echo "download files"
LOGS_FOLDER="logs"
mkdir ${LOGS_FOLDER}/${EXP_NAME}
mkdir ${LOGS_FOLDER}/${EXP_NAME}/"devices"
mkdir ${LOGS_FOLDER}/${EXP_NAME}/"kafka-consumer"

ssh fmontelli@137.204.74.56 "ls -1t ${ROOT}/${CODE_FOLDER}/webserver/mylogs2/*.csv | head -1 | xargs -I{} mv {} ${ROOT}/${CODE_FOLDER}/webserver/mylogs2/${EXP_NAME}.csv"
scp fmontelli@137.204.74.56:${ROOT}/${CODE_FOLDER}/webserver/mylogs2/${EXP_NAME}.csv ~/tesi/${CODE_FOLDER}/logs/${EXP_NAME}/webserver/ &>/dev/null

#Fare la copia dei log verso questa macchina
scp fmontelli@${DEVICE_IP}:${ROOT}/${CODE_FOLDER}/devices/thermometerMQTT3-remoteVersion/mylogs/${EXP_NAME}/*.csv ~/tesi/${CODE_FOLDER}/logs/${EXP_NAME}/devices/
fi
