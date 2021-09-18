#!/bin/bash
EXP_NAME=$1
timeout 60m ./launchRemoteExperiment.sh 5 1000 1 1000 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 5 100 1 9000 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 5 40 1 22500 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 5 20 1 45000 0 0 1000 ${EXP_NAME}
timeout 60m ./launchRemoteExperiment.sh 5 10 1 90000 0 0 1000 ${EXP_NANE}
timeout 60m ./launchRemoteExperiment.sh 5 8 1 112500 0 0 1000 ${EXP_NAME}

