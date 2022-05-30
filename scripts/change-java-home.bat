@ECHO off
cls
:start
ECHO.
ECHO Choose the java version to use. The options are:
ECHO 11. set JAVA_HOME to java 11
ECHO 17. set JAVA_HOME to java 17
set choice=
set /p choice=Type the java version that you want to use. 
@REM if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='11' goto java11
if '%choice%'=='17' goto java17
ECHO "%choice%" is not valid, try again
ECHO.
goto start
:java11
@ECHO on
SETX JAVA_HOME "C:\Program Files\AdoptOpenJDK\jdk-11.0.5.10-hotspot"
@ECHO off
goto end
:java17
@ECHO on
SETX JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.2.8-hotspot"
@ECHO off
goto end
:end
pause