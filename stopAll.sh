#!/bin/bash

docker-compose down

echo "stop remote experiment on 58"
ssh fmontelli@137.204.74.58 /home/fmontelli/demoweb2_performance_test2/stopExperiment.sh &

echo "stop remote experiment on 57"
ssh fmontelli@137.204.74.57 /home/fmontelli/demoweb2_performance_test2/stopExperiment.sh &

echo "stop webserver on 56"
ssh fmontelli@137.204.74.56  docker-compose -f /home/fmontelli/demoweb2_performance_websplit/webserver/docker-compose.yml down &
