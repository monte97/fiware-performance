#!/bin/bash
SET_ID="debug"

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

rm ${LOG_FILE}
touch ${LOG_FILE}
mkdir ${LOGS_FOLDER}/${SET_ID}

./supportScripts/launchRemoteExperiment.sh 2 200 1 1000 0 0 1000 "debug" ${SET_ID}

./supportScripts/downloadMissing.sh ${LOG_FILE}
./supportScripts/stopAll.sh
