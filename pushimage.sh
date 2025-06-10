#!/bin/bash

echo "Logging into Azure Container Registry"
az acr login --name securitylabregistry


echo "Tagging Docker image"
docker tag bkimminich/juice-shop securitylabregistry.azurecr.io/juice-shop:latest


echo "Pushing Docker image"
docker push securitylabregistry.azurecr.io/juice-shop:latest


echo "Completed"