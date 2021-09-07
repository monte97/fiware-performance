#!/bin/bash

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi
if [ -f kafka-docker/.env ]; then
  export $(echo $(cat kafka-docker/.env | sed 's/#.*//g'| xargs) | envsubst)
fi

echo "setup fiware"
ssh fmontelli@${FIWARE_IP}  docker-compose -f ${ROOT}/${CODE_FOLDER}/docker-compose-fiware.yml build

echo "setup draco"
ssh fmontelli@${DRACO_IP} docker-compose -f ${ROOT}/${CODE_FOLDER}/docker-compose-draco.yml build
