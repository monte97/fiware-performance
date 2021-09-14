#!/bin/bash
if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

echo "stop devices on ${DEVICE_IP}"
#ssh fmontelli@${DEVICE_IP} "docker ps --filter name=device* --filter status=running -aq | xargs docker stop"
ssh fmontelli@${DEVICE_IP} docker rm $(docker container ls -aq --filter name=device*)
#ssh fmontelli@${DEVICE_IP} "docker container ls -aq --filter name=device*"
