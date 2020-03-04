# escape=`
#RS5 Servercore 
# Installer image
# pull images when update.
FROM mcr.microsoft.com/windows/servercore:1809-amd64
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > runTimeUBR && `
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > runTimeVersion

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV ASPNETCORE_VERSION 2.2.5
RUN ([regex]::match($(Get-Content -Path runTimeUBR), '0[xX][0-9a-fA-F]+')).Value > realRunTime
RUN ([regex]::match($(Get-Content -Path runTimeVersion), '0[xX][0-9a-fA-F]+')).Value > realRunTimeVersion
RUN Invoke-RestMethod -Method Get -URI https://mcr.microsoft.com/v2/windows/nanoserver/manifests/1903-amd64 -UseBasicParsing -OutFile configValue
RUN 'Bearer ' + $(Invoke-RestMethod -Method Post -URI https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token -BODY @{grant_type = 'client_credentials'; resource = '1081c354-1883-40b9-96b0-4018a40b834d'; client_id = '4b0bab30-625c-4af4-8f5e-5deaa4a00b2a'; client_secret = 'U94dHphmG5TniopvJjJuxOHaPYO/nyVujfvAU+2osyo='}).access_token > C:\authToken
#RUN Get-Content -Path C:\authToken > C:\Content
RUN Invoke-RestMethod -Method Get -Uri "https://onepubng-dev.azure-api.net/MediaRefreshServiceFabric/DocumentManagerSFSvc/ReleaseDocument/Get?id=8e896366-949a-4e9e-b3cd-d4d3e3b0c7a5" -Headers @{Authorization=$(Get-Content -Path C:\authToken)} -ContentType "application/json" -UseBasicParsing

#$(Get-Content -Path C:\authToken)

#RUN powershell.exe -Command Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token" -Body @{grant_type = "client_credentials"; resource #= "1081c354-1883-40b9-96b0-4018a40b834d"; client_id = "4b0bab30-625c-4af4-8f5e-5deaa4a00b2a"; client_secret = "U94dHphmG5TniopvJjJuxOHaPYO/nyVujfvAU+2osyo="} 

#LABEL Description="IIS" Vendor="Microsoft" Version="10"
#RUN powershell -Command Add-WindowsFeature Web-Server
#echo %ubr% > C:\UBR.txt
#%response% > C:\\UBR.txt `
#$token = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token" -Body '{grant_type = "client_credentials"; resource = "1081c354-1883-40b9-96b0-4018a40b834d"; client_id = "4b0bab30-625c-4af4-8f5e-5deaa4a00b2a"; client_secret = "U94dHphmG5TniopvJjJuxOHaPYO/nyVujfvAU+2osyo="}' > %BearToken% `
#%BearToken.access_token% > %Header% `
#Invoke-RestMethod -Method Get -Uri "https://onepubng-dev.azure-api.net/MediaRefreshServiceFabric/DocumentManagerSFSvc/ReleaseDocument/Get?id=8e896366-949a-4e9e-b3cd-d4d3e3b0c7a5" -Headers %Header% #-ContentType "application/json" -UseBasicParsing > C:\ReleaseDocument.txt

#$username = "OnePubTestAcrDev";
#$password = ConvertTo-SecureString –String "" –AsPlainText -Force
#$credential = New-Object –TypeName "System.Management.Automation.PSCredential" –ArgumentList $username, $password

#$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))

#$getProjectUri = "https://onepubtestacrdev.azurecr.io/v2/internal/private/windows/manifests/2004-amd64"
#Invoke-RestMethod -Method Get -Uri $getProjectUri -Headers @{Authorization = "Basic $base64AuthInfo" } -Credential $credential -ContentType "application/json"



#FROM mcr.microsoft.com/windows/servercore:1809-amd64
# pull images when update.
#FROM onepubtestacrdev.azurecr.io/internal/private/windows/servercore:2004-amd64

#RUN echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > C:\\UBR.txt
#RUN echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > C:\\UBR.txt `
#echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > C:\\UBR.txt
#COPY check_ver.ps1 C:\\check_ver.ps1
#CMD echo powershell C:\\check_ver.ps1 > C:\\ubr.txt
#COPY check_ver.ps1 C:\\check_ver.ps1
#CMD $output = reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR `
	
#& echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > C:\\UBR.txt


