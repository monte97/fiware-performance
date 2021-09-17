#!/bin/bash
EXP_NAME=$1
./launchRemoteExperiment.sh 1 200 1 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 10 200 1 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 25 200 1 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 50 200 1 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 100 200 1 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 125 200 1 4500 0 0 1000 ${EXP_NAME}

