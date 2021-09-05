#!/bin/bash
docker ps --filter name=term* --filter status=running -aq | xargs docker stop
docker-compose down
docker rm $(docker container ls -aq --filter name=term*) -f
