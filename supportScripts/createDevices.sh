#!/bin/bash
FROM=$1
NUM=$2
TIME=$3
HOW_MANY=$4
HOW_OFTEN=$5
STEP=$6
PAYLOAD_KB=$7
EXP_NAME=$8

echo ${EXP_NAME}

#build image
echo $(pwd)
cd  ~/tmp/fiware-performance/devices/simpleDevice
docker build -t monte/device .

#sleep 1m

#start devices
for ((i=${FROM}; i<${FROM}+${NUM}; i++))
do
  echo ${i}
  ./launcher.sh ${i} off ${TIME} ${EXP_NAME} ${HOW_MANY} ${HOW_OFTEN} ${STEP} ${PAYLOAD_KB}
done
