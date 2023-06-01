setx path "%path%;%USERPROFILE%/.deno/bin"

Set InstallPath=%~dp0
Set EnvFile="%InstallPath%\..\local\windows-env.local"
for /F %A in ("%EnvFile%") do SETX "%A