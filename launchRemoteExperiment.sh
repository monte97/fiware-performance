#!/bin/bash

NUM_58=$1
NUM_57=$2

TERM_TIME=$3
SUB_NUM=$4
HOW_MANY_MESSAGES=$5
HOW_OFTEN_SPEEDUP=$6
SPEEDUP=$7
PAYLOAD_KB=$8

START_58=0
START_57=7777
EXP_NAME=${NUM_58}_${NUM_57}_${TERM_TIME}_${HOW_MANY_MESSAGES}_${SUB_NUM}_${HOW_OFTEN_SPEEDUP}_${SPEEDUP}_${PAYLOAD_KB}_`date +"%G%m%d_%H%M"`
echo ${EXP_NAME}

#avviare fiware
echo "setup fiware"
./setupFiware.sh

ROOT="/home/fmontelli"
CODE_FOLDER="demoweb2_performance_websplit"


echo "launch webserver"
ssh fmontelli@137.204.74.56  docker-compose -f ${ROOT}/${CODE_FOLDER}/webserver/docker-compose.yml up --build &>/dev/null &
sleep 1m

echo "setup subscriptions"
#una sottoscrizione viene già creata dallo script di setup
echo "Begin create subscriptions"
for ((i=0; i<${SUB_NUM}; i++))
do
  echo "sub ${i}"
  curl -iX POST \
    --url 'http://localhost:8082/v2/subscriptions' \
    --header 'Content-Type: application/json' \
    --header 'fiware-service: openiot' \
    --header 'fiware-servicepath: /' \
    --data '{
    "description": "Notify me when any Thermometer changes state",
    "subject": {
    "entities": [{"idPattern": ".*","type": "Thermometer"}],
    "condition": {
      "attrs": ["Status", "Temperature", "Timestamp"]
    }
    },
    "notification": {
    "http": {
      "url": "http://137.204.74.56:8080/api/fiware/notification/thermometer"
    },
    "attrsFormat" : "keyValues"
    }
  }' &>/dev/null
done



echo "Finish subscriptions creation"
#mettre in esecuzione esperimento remoto
echo "launch on 58"
ssh fmontelli@137.204.74.58 ${ROOT}/${CODE_FOLDER}/createDevices.sh ${START_58} ${NUM_58} ${TERM_TIME} ${SUB_NUM} ${HOW_MANY_MESSAGES} ${HOW_OFTEN_SPEEDUP} ${SPEEDUP} ${PAYLOAD_KB} ${EXP_NAME} $>/dev/null &

echo "launch on 57"
ssh fmontelli@137.204.74.57 ${ROOT}/${CODE_FOLDER}/createDevices.sh ${START_57} ${NUM_57} ${TERM_TIME} ${SUB_NUM} ${HOW_MANY_MESSAGES} ${HOW_OFTEN_SPEEDUP} ${SPEEDUP} ${PAYLOAD_KB} ${EXP_NAME} $>/dev/null &

sleep 1m
#ottenere conteggio
count_58=$(($(ssh fmontelli@137.204.74.58 "docker ps | wc -l")-1))
#attendere che il conteggio arrivi al valore desiderato
while [ "${count_58}" != "${NUM_58}" ]
do
  count_58=$(($(ssh fmontelli@137.204.74.58 "docker ps | wc -l")-1))
  sleep 1m
done

echo "count_58 ok"

#ottenere conteggio
sleep 1m
count_57=$(($(ssh fmontelli@137.204.74.57 "docker ps | wc -l")-1))
#attender0e che il conteggio arrivi al valore desiderato
while [ "${count_57}" != "${NUM_57}" ]
do
  count_57=$(($(ssh fmontelli@137.204.74.57 "docker ps | wc -l")-1))
  sleep 1m
done

echo "count_57 ok"

echo "on"
#dare on  a tutti i device, on deve essere mandato ad OCB
for ((i=${START_58}; i<${START_58}+${NUM_58}; i++))
do
  echo ${i}
  curl \
    --max-time 10 \
    --connect-timeout 2 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -iX PATCH \
    --url "http://137.204.74.59:8082/v2/entities/urn:ngsi-ld:thermometer:${i}/attrs" \
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

echo "on"
#dare on  a tutti i device, on deve essere mandato ad OCB
for ((i=${START_57}; i<${START_57}+${NUM_57}; i++))
do
  echo ${i}
  curl \
    --max-time 10 \
    --connect-timeout 2 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -iX PATCH \
    --url "http://137.204.74.59:8082/v2/entities/urn:ngsi-ld:thermometer:${i}/attrs" \
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

echo "wait completion 58"
count_58=$(($(ssh fmontelli@137.204.74.58 "docker ps | wc -l")-1))
while [ "${count_58}" != "0" ]
do
  count_58=$(($(ssh fmontelli@137.204.74.58 "docker ps | wc -l")-1))
  sleep 1m
done

echo "wait completion 57"
count_57=$(($(ssh fmontelli@137.204.74.57 "docker ps | wc -l")-1))
while [ "${count_57}" != "0" ]
do
  count_57=$(($(ssh fmontelli@137.204.74.57 "docker ps | wc -l")-1))
  sleep 1m
done

echo "wait before stop"
#sleep 15m

echo "stop remote experiment on 58"
ssh fmontelli@137.204.74.58 ${ROOT}/${CODE_FOLDER}/stopExperiment.sh &>/dev/null

echo "stop remote experiment on 57"
ssh fmontelli@137.204.74.57 ${ROOT}/${CODE_FOLDER}/stopExperiment.sh &>/dev/null

echo "stop local experiment"
./stopExperiment.sh &>/dev/null

echo "stop one more time"
./stopAll.sh &>/dev/null
echo "download files"

LOGS_FOLDER="logs"
mkdir ${LOGS_FOLDER}/${EXP_NAME}
mkdir ${LOGS_FOLDER}/${EXP_NAME}/"devices"
mkdir ${LOGS_FOLDER}/${EXP_NAME}/"webserver"

ssh fmontelli@137.204.74.56 "ls -1t ${ROOT}/${CODE_FOLDER}/webserver/mylogs2/*.csv | head -1 | xargs -I{} mv {} ${ROOT}/${CODE_FOLDER}/webserver/mylogs2/${EXP_NAME}.csv"
scp fmontelli@137.204.74.56:${ROOT}/${CODE_FOLDER}/webserver/mylogs2/${EXP_NAME}.csv ~/tesi/${CODE_FOLDER}/logs/${EXP_NAME}/webserver/ &>/dev/null

#Fare la copia dei log verso questa macchina
scp fmontelli@137.204.74.58:${ROOT}/${CODE_FOLDER}/devices/thermometerMQTT3-remoteVersion/mylogs/${EXP_NAME}/*.csv ~/tesi/${CODE_FOLDER}/logs/${EXP_NAME}/devices/ &>/dev/null

scp fmontelli@137.204.74.57:${ROOT}/${CODE_FOLDER}/devices/thermometerMQTT3-remoteVersion/mylogs2/${EXP_NAME}/*.csv ~/tesi/${CODE_FOLDER}/logs/${EXP_NAME}/devices/ &>/dev/null
