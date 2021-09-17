#!/bin/bash
EXP_NAME=$1
./launchRemoteExperiment.sh 50 200 1 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 50 200 10 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 50 200 100 4500 0 0 1000 ${EXP_NAME}
#./launchRemoteExperiment.sh 50 200 1 4500 0 0 1000 subsV2
#./launchRemoteExperiment.sh 50 200 10 4500 0 0 1000 subsV2
#./launchRemoteExperiment.sh 50 200 100 4500 0 0 1000 subsV2
