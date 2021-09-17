#!/bin/bash
SET_ID=$1
./testScripts/testDeviceOfficial.sh "DEVICE_${SET_ID}"
./testScripts/testFreqeuncyOfficial.sh "FREQUENCY_${SET_ID}"
./testScripts/testPayloadOfficial.sh "PAYLOAD_${SET_ID}"
./testScripts/testSubsOfficial.sh "SUB_${SET_ID}"
