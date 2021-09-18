#!/bin/bash
EXP_NAME=$1
timeout 60m ./launchRemoteExperiment.sh 5 200 1 4500 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 5 200 1 4500 0 0 10000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 5 200 1 4500 0 0 50000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 5 200 1 4500 0 0 100000 ${EXP_NAME}
