#!/bin/bash

docker pull $SOURCE_IMAGE

echo "Logging into Azure Container Registry"
az acr login --name securitylabregistry1


echo "Tagging Docker image from source: $SOURCE_IMAGE"
docker tag $SOURCE_IMAGE securitylabregistry1.azurecr.io/${TARGET_IMAGE}:latest


echo "Pushing Docker image"
docker push securitylabregistry1.azurecr.io/${TARGET_IMAGE}:latest


echo "Completed"