#!/bin/bash
EXP_NAME=$1
EXP_SET=$2
timeout 60m ./launchRemoteExperiment.sh 50 200 1 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./launchRemoteExperiment.sh 50 200 5 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./launchRemoteExperiment.sh 50 200 10 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./launchRemoteExperiment.sh 50 200 15 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./launchRemoteExperiment.sh 50 200 20 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./launchRemoteExperiment.sh 50 200 25 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
timeout 60m ./launchRemoteExperiment.sh 50 200 30 4500 0 0 1000 ${EXP_NAME} ${EXP_SET}
