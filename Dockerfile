FROM mcr.microsoft.com/windows:1903
ARG CERT
ARG CONFIGURL
# generate runtime currentVersion & UBR.
RUN echo %CERT% > cert
RUN echo %CONFIGURL% > configUrl
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > runTimeUBR
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > runTimeVersion
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Retrieve .NET Core SDK
ENV ASPNETCORE_VERSION 2.2.5
# Parse hex Version & UBR from file.
RUN ([regex]::match($(Get-Content -Path runTimeUBR), '0[xX][0-9a-fA-F]+')).Value > realRunTime
RUN ([regex]::match($(Get-Content -Path runTimeVersion), '0[xX][0-9a-fA-F]+')).Value > realRunTimeVersion
# Retrieve config file from ACR
RUN Invoke-RestMethod -Method Get -URI https://mcr.microsoft.com/v2/windows/manifests/1903-amd64 -UseBasicParsing -OutFile configValue
# Generate Bearer Token.
RUN 'Bearer ' + $(Invoke-RestMethod -Method Post -URI https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token -BODY @{grant_type = 'client_credentials'; resource = '1081c354-1883-40b9-96b0-4018a40b834d'; client_id = '4b0bab30-625c-4af4-8f5e-5deaa4a00b2a'; client_secret = $(Get-Content -Path cert)}).access_token > authToken
# manipulate config Value.
RUN $(Get-Content -Path configValue) -replace '\\', '' > configValue_update
RUN $(Get-Content -Path configValue_update) -replace '\"{', '{' > configValue_update2
RUN $(Get-Content -Path configValue_update2) -replace '}\"', '}' > configValue_update3
# trigger container validation.
RUN Invoke-RestMethod -Method POST -Uri "https://onepubng-dev.azure-api.net/MediaRefreshServiceFabric/ServerContainerSFSvc/ServerContainerRelease/ValidateContainerInfo" -Headers @{Authorization=$(Get-Content -Path authToken); runTimeBuildVersion='14393'; runTimeUbr='3443'; product='Windows 10 1607'} -Body $(Get-Content -Path configValue_update3) -ContentType "application/json" -UseBasicParsing
      
FROM mcr.microsoft.com/windows:1903-amd64
ARG CERT
ARG CONFIGURL
# generate runtime currentVersion & UBR.
RUN echo %CERT% > cert
RUN echo %CONFIGURL% > configUrl
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > runTimeUBR
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > runTimeVersion
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Retrieve .NET Core SDK
ENV ASPNETCORE_VERSION 2.2.5
# Parse hex Version & UBR from file.
RUN ([regex]::match($(Get-Content -Path runTimeUBR), '0[xX][0-9a-fA-F]+')).Value > realRunTime
RUN ([regex]::match($(Get-Content -Path runTimeVersion), '0[xX][0-9a-fA-F]+')).Value > realRunTimeVersion
# Retrieve config file from ACR
RUN Invoke-RestMethod -Method Get -URI https://mcr.microsoft.com/v2/windows/manifests/1903-amd64 -UseBasicParsing -OutFile configValue
# Generate Bearer Token.
RUN 'Bearer ' + $(Invoke-RestMethod -Method Post -URI https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token -BODY @{grant_type = 'client_credentials'; resource = '1081c354-1883-40b9-96b0-4018a40b834d'; client_id = '4b0bab30-625c-4af4-8f5e-5deaa4a00b2a'; client_secret = $(Get-Content -Path cert)}).access_token > authToken
# manipulate config Value.
RUN $(Get-Content -Path configValue) -replace '\\', '' > configValue_update
RUN $(Get-Content -Path configValue_update) -replace '\"{', '{' > configValue_update2
RUN $(Get-Content -Path configValue_update2) -replace '}\"', '}' > configValue_update3
# trigger container validation.
RUN Invoke-RestMethod -Method POST -Uri "https://onepubng-dev.azure-api.net/MediaRefreshServiceFabric/ServerContainerSFSvc/ServerContainerRelease/ValidateContainerInfo" -Headers @{Authorization=$(Get-Content -Path authToken); runTimeBuildVersion='14393'; runTimeUbr='3443'; product='Windows 10 1607'} -Body $(Get-Content -Path configValue_update3) -ContentType "application/json" -UseBasicParsing
