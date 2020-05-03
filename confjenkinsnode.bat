@ECHO OFF
@setlocal enableextensions
@cd /d "%~dp0"
title ConfigureJenkinsslavenodes
set /p username=Username for Jenkins login?
set /p password=Password for Jenkins?
set /p URL=Mention the jenkins url you need to connect eg. http://^<name^>:8080?
set /p nodename=Tell the node name you want to create?
set /p executors=No of executors required?
set /p outputdir=Specify the path for configuring node? eg. Users\admin\Documents=^>
curl -u %username%:%password% %URL%/jnlpJars/agent.jar --output %outputdir%\agent.jar
curl -u %username%:%password% %URL%/jnlpJars/jenkins-cli.jar --output %outputdir%\jenkins-cli.jar
echo ^<?xml version="1.1" encoding="UTF-8"?^>^<slave^>^<name^>%nodename%^</name^>^<description^>^</description^>^<numExecutors^>%executors%^</numExecutors^>^<remoteFS^>%outputdir%^</remoteFS^>^<mode^>EXCLUSIVE^</mode^>^<retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/^>^<launcher class="hudson.slaves.JNLPLauncher"^>^<workDirSettings^>^<disabled^>false^</disabled^>^<internalDir^>remoting^</internalDir^>^<failIfWorkDirIsMissing^>false^</failIfWorkDirIsMissing^>^</workDirSettings^>^</launcher^>^<label^>%nodename%^</label^>^<nodeProperties/^>^</slave^> > %outputdir%\node.xml
sleep 2
sc query | grep "SERVICE_NAME: jenkinsslave" > %outputdir%\scnamejenkins
FOR /F "tokens=* USEBACKQ" %%F IN (%outputdir%\scnamejenkins) DO (
SET result=%%F
)
echo %result:~14%
sc query %result:~14%
if %ERRORLEVEL% neq 1060 (
 	sc stop %result:~14% && sc delete %result:~14% )
sleep 2
taskkill /f /im "jp2launcher.exe"
sleep 2
java -jar %outputdir%\jenkins-cli.jar -s %URL%/ -auth %username%:%password% delete-node %nodename%
sleep 2
java -jar %outputdir%\jenkins-cli.jar -s %URL%/ -auth %username%:%password% create-node %nodename% < %outputdir%\node.xml
sleep 5
curl -u %username%:%password% %URL%/computer/%nodename%/slave-agent.jnlp --output %outputdir%\slave-agent.jnlp
curl -u %username%:%password% %URL%/jnlpJars/slave.jar --output %outputdir%\slave.jar
curl -u %username%:%password% %URL%/jnlpJars/jenkins-slave.exe --output %outputdir%\jenkins-slave.exe
sleep 2
start /WAIT /B %outputdir%\slave-agent.jnlp &&^
sleep 7
REM sc create jenkinsslave binPath= "%outputdir%\jenkins-slave.exe" type= own start= auto error= normal DisplayName= jenkinsslave
REM REG ADD HKLM\SYSTEM\CurrentControlSet\Services\jenkinsslave /v Description /t REG_SZ /d "This service runs an agent for Jenkins automation server."
REM REG ADD HKLM\SYSTEM\CurrentControlSet\Services\jenkinsslave /v DisplayName /t REG_SZ /d "jenkinsslave"
REM REG ADD HKLM\SYSTEM\CurrentControlSet\Services\jenkinsslave /v ImagePath /t REG_EXPAND_SZ /d "C:\Users\ingres\Documents\jenkins-slave.exe"
REM REG DELETE HKLM\SYSTEM\CurrentControlSet\Control /v ServicesPipeTimeout
REM REG ADD HKLM\SYSTEM\CurrentControlSet\Control /v ServicesPipeTimeout /t REG_DWORD /d 98304
REM sleep 3
REM sc start jenkinsslave


