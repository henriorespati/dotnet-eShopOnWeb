#! /bin/bash

oc new-app dotnet:7.0-ubi8~https://github.com/henriorespati/dotnet-eShopOnWeb.git \
  --name web-app \
  --build-env DOTNET_STARTUP_PROJECT=src/Web/Web.csproj \
  -e ASPNETCORE_URLS='http://+:8080' \
  --strategy=source

oc set volume deployment/web-app --add \
  --name appsettings-vol \
  --mount-path /opt/app-root/app/appsettings.json \
  --configmap-name=appsettings-cm \
  --sub-path=appsettings-passwordupdated.json

oc create route edge --service=web-app
