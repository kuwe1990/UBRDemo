FROM onepubtestacrdev.azurecr.io/public/windows/servercore:1903
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
RUN $(Get-Content -Path configValue) -replace '\\', '' > configValue_update
RUN $(Get-Content -Path configValue_update) -replace '\"{', '{' > configValue_update2
RUN $(Get-Content -Path configValue_update2) -replace '}\"', '}' > configValue_update3