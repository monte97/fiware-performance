#!/bin/bash
EXP_NAME=$1
./launchRemoteExperiment.sh 50 200 1 4500 0 0 1000 ${EXP_NAME}
./launchRemoteExperiment.sh 50 200 1 4500 0 0 10000 ${EXP_NAME}
./launchRemoteExperiment.sh 50 200 1 4500 0 0 100000 ${EXP_NAME}