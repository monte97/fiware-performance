#!/bin/bash
SET_ID=$1
mkdir master_logs/${SET_ID}

./testScripts/testDeviceOfficial.sh "DEVICE_${SET_ID}"
./testScripts/testFreqeuncyOfficial.sh "FREQUENCY_${SET_ID}"
./testScripts/testPayloadOfficial.sh "PAYLOAD_${SET_ID}"
./testScripts/testSubsOfficial.sh "SUB_${SET_ID}"
./testScripts/testPayloadFewDeviceOfficial.sh "PAYLOADFEW_${SET_ID}"
./testScripts/testSubsFewDeviceOfficial.sh "SUBFEW_${SET_ID}"

mv master_logs/*_${SET_ID} master_logs/${SET_ID}
