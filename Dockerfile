# escape=`
#RS5 Servercore 
# Installer image

# pull images when update.
FROM mcr.microsoft.com/windows/nanoserver:1809-arm32v7
RUN echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > %ubr% `
echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > %currentVersion% `
Invoke-RestMethod -Method Get -URI https://mcr.microsoft.com/v2/windows/nanoserver/manifests/1903-amd64 > %response% `
%response% > C:\\UBR.txt





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


