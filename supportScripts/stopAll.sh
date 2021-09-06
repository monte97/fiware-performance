#!/bin/bash
if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

echo "stop fiware on ${FIWARE_IP}"
ssh fmontelli@${FIWARE_IP}  docker-compose -f ${ROOT}/${CODE_FOLDER}/docker-compose-fiware.yml down

echo "stop draco on ${DRACO_IP}"
ssh fmontelli@${DRACO_IP}  docker-compose -f ${ROOT}/${CODE_FOLDER}/docker-compose-draco.yml down

echo "stop devices on ${DEVICE_IP}"
docker ps --filter name=term* --filter status=running -aq | xargs docker stop
docker rm $(docker container ls -aq --filter name=term*) -f
