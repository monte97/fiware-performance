#!/bin/bash
SET_ID=$1

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

rm ${LOG_FILE}
touch ${LOG_FILE}

mkdir ${LOGS_FOLDER}/${SET_ID}

./testScripts/testDeviceOfficial.sh "DEVICE_${SET_ID}" ${SET_ID}
./testScripts/testFreqeuncyOfficial.sh "FREQUENCY_${SET_ID}" ${SET_ID}
./testScripts/testPayloadOfficial.sh "PAYLOAD_${SET_ID}" ${SET_ID}
./testScripts/testSubsOfficial.sh "SUB_${SET_ID}" ${SET_ID}

mv ${LOGS_FOLDER}/*_${SET_ID} ${LOGS_FOLDER}/${SET_ID}

./supportScripts/downloadMissing.sh ${LOG_FILE}
