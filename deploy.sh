# Build images
docker build -t danielvdm/multi-client:latest -t danielvdm/multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t danielvdm/multi-api:latest    -t danielvdm/multi-api:$GIT_SHA    -f ./api/Dockerfile    ./api
docker build -t danielvdm/multi-worker:latest -t danielvdm/multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

# Push images to Dockerhub
docker push danielvdm/multi-client:latest
docker push danielvdm/multi-api:latest
docker push danielvdm/multi-worker:latest

docker push danielvdm/multi-client:$GIT_SHA
docker push danielvdm/multi-api:$GIT_SHA
docker push danielvdm/multi-worker:$GIT_SHA

# Apply kubernetes config files
kubectl apply -f k8s

# Update images in kubernetes
kubectl set image deployments/client-deployment client=danielvdm/multi-client:$GIT_SHA
kubectl set image deployments/api-deployment    api=danielvdm/multi-api:$GIT_SHA
kubectl set image deployments/worker-deployment worker=danielvdm/multi-worker:$GIT_SHA