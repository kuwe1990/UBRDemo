FROM onepubacrprod.azurecr.io/internal/private/windows/nanoserver:1903
ARG CERT
ARG CONFIGURL
ARG AUTH
# generate runtime currentVersion & UBR.
RUN echo %CERT% > cert
RUN echo %CONFIGURL% > configUrl
RUN echo %AUTH% > authValue
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > runTimeUBR
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > runTimeVersion
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Retrieve .NET Core SDK
RUN 'Basic ' + $(Get-Content -Path authValue) > auth
# Parse hex Version & UBR from file.
RUN ([regex]::match($(Get-Content -Path runTimeUBR), '0[xX][0-9a-fA-F]+')).Value > realRunTime
RUN ([regex]::match($(Get-Content -Path runTimeVersion), '\b\d{5}\b')).Value > realRunTimeVersion
# Retrieve config file from ACR
RUN Invoke-RestMethod -Method Get -URI https://onepubacrprod.azurecr.io/v2/internal/private/windows/nanoserver/manifests/1903-amd64 -Headers @{Authorization=$(Get-Content -Path auth)} -UseBasicParsing -OutFile configValue
# Generate Bearer Token.
RUN 'Bearer ' + $(Invoke-RestMethod -Method Post -URI https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token -BODY @{grant_type = 'client_credentials'; resource = '9dd95a46-35d9-4750-b01a-3c8c42ebc22c'; client_id = '30c9a422-d0d1-4a82-b7e8-2c81c074d273'; client_secret = $(Get-Content -Path cert)}).access_token > authToken
# manipulate config Value.
RUN $(Get-Content -Path configValue) -replace '\\', '' > configValue_update
RUN $(Get-Content -Path configValue_update) -replace '\"{', '{' > configValue_update2
RUN $(Get-Content -Path configValue_update2) -replace '}\"', '}' > configValue_update3
# trigger container validation.
RUN Invoke-RestMethod -Method POST -Uri "https://onepubng-prod.azure-api.net/MediaRefreshServiceFabric/ServerContainerSFSvc/ServerContainerRelease/ValidateContainerInfo" -Headers @{Authorization=$(Get-Content -Path authToken); runTimeBuildVersion=$(Get-Content -Path realRunTimeVersion); runTimeUbr=$(Get-Content -Path realRunTime); product='Windows 10 1903'; hostUrl='onepubacrprod.azurecr.io/internal/private'} -Body $(Get-Content -Path configValue_update3) -ContentType "application/json" -UseBasicParsing
    
FROM onepubacrprod.azurecr.io/internal/private/windows/nanoserver:1903-amd64
ARG CERT
ARG CONFIGURL
# generate runtime currentVersion & UBR.
RUN echo %CERT% > cert
RUN echo %CONFIGURL% > configUrl
RUN echo %AUTH% > authValue
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > runTimeUBR
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > runTimeVersion
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Retrieve .NET Core SDK
RUN 'Basic ' + $(Get-Content -Path authValue) > auth
# Parse hex Version & UBR from file.
RUN ([regex]::match($(Get-Content -Path runTimeUBR), '0[xX][0-9a-fA-F]+')).Value > realRunTime
RUN ([regex]::match($(Get-Content -Path runTimeVersion), '\b\d{5}\b')).Value > realRunTimeVersion
# Retrieve config file from ACR
RUN Invoke-RestMethod -Method Get -URI https://onepubacrprod.azurecr.io/v2/internal/private/windows/nanoserver/manifests/1903-amd64 -Headers @{Authorization=$(Get-Content -Path auth)} -UseBasicParsing -OutFile configValue
# Generate Bearer Token.
RUN 'Bearer ' + $(Invoke-RestMethod -Method Post -URI https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token -BODY @{grant_type = 'client_credentials'; resource = '9dd95a46-35d9-4750-b01a-3c8c42ebc22c'; client_id = '30c9a422-d0d1-4a82-b7e8-2c81c074d273'; client_secret = $(Get-Content -Path cert)}).access_token > authToken
# manipulate config Value.
RUN $(Get-Content -Path configValue) -replace '\\', '' > configValue_update
RUN $(Get-Content -Path configValue_update) -replace '\"{', '{' > configValue_update2
RUN $(Get-Content -Path configValue_update2) -replace '}\"', '}' > configValue_update3
# trigger container validation.
RUN Invoke-RestMethod -Method POST -Uri "https://onepubng-prod.azure-api.net/MediaRefreshServiceFabric/ServerContainerSFSvc/ServerContainerRelease/ValidateContainerInfo" -Headers @{Authorization=$(Get-Content -Path authToken); runTimeBuildVersion=$(Get-Content -Path realRunTimeVersion); runTimeUbr=$(Get-Content -Path realRunTime); product='Windows 10 1903'; hostUrl='onepubacrprod.azurecr.io/internal/private'} -Body $(Get-Content -Path configValue_update3) -ContentType "application/json" -UseBasicParsing