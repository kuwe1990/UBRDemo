FROM onepubtestacrdev.azurecr.io/public/windows/servercore:1903
ARG CERT
ARG AUTH
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v UBR > runTimeUBR
RUN reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild > runTimeVersion