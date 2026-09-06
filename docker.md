docker ps
docker images
docker logs
docker exec
docker stop
docker rm
docker build
docker tag
docker push



Problem:
Port 8081 already in use.

Investigation:

netstat -ano | findstr :8081

Cause:
Another process/container was listening on port 8081.

Resolution:
Identify process/container and stop it or change port mapping.
