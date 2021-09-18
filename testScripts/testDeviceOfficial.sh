#!/bin/bash
EXP_NAME=$1
timeout 60m ./launchRemoteExperiment.sh 1 200 1 4500 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 10 200 1 4500 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 25 200 1 4500 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 50 200 1 4500 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 100 200 1 4500 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 125 200 1 4500 0 0 1000 ${EXP_NAME}

