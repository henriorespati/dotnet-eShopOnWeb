#! /bin/bash

export PASSWORD=<<PASSWORD>>
sed 's/CHANGE_DB_PASSWORD/'"$PASSWORD"'/g' assets/appsettings.json > assets/appsettings-passwordupdated.json
oc create cm appsettings-cm --from-file=assets/appsettings-passwordupdated.json

oc new-app dotnet:7.0-ubi8~https://github.com/henriorespati/dotnet-eShopOnWeb.git \
  --name public-api \
  --build-env DOTNET_STARTUP_PROJECT=src/PublicApi/PublicApi.csproj \
  -e ASPNETCORE_URLS='http://+:8080' \
  --strategy=source

oc set volume deployment/public-api --add \
  --name appsettings-vol \
  --mount-path /opt/app-root/app/appsettings.json \
  --configmap-name=appsettings-cm \
  --sub-path=appsettings-passwordupdated.json
