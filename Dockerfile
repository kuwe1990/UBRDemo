# escape=`
#RS5 Servercore 
# Installer image

FROM mcr.microsoft.com/windows/servercore:1809-amd64

RUN echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > C:\\UBR.txt `
echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > C:\\UBR.txt
#COPY check_ver.ps1 C:\\check_ver.ps1
#CMD echo powershell C:\\check_ver.ps1 > C:\\ubr.txt
#COPY check_ver.ps1 C:\\check_ver.ps1
#CMD $output = reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR `
	
#& echo reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > C:\\UBR.txt


