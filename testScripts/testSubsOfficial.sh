#!/bin/bash
EXP_NAME=$1
EXP_SET=$2
timeout 60m ./supportScripts/launchRemoteExperiment.sh 25 200 1 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./supportScripts/launchRemoteExperiment.sh 25 200 2 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./supportScripts/launchRemoteExperiment.sh 25 200 3 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./supportScripts/launchRemoteExperiment.sh 25 200 4 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./supportScripts/launchRemoteExperiment.sh 25 200 5 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./supportScripts/launchRemoteExperiment.sh 25 200 10 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
