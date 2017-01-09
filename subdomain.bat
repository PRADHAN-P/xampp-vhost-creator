@echo off
cd /D %~dp0
SET XAMPPDIR=%~dp0
SET BASEURL=%XAMPPDIR%htdocs\
SET SUFFIX=local

@echo off
echo ####### XAMPP Domain Creator ######
echo:
echo:
@ECHO OFF
:sitenameprompt
::ask for a sitename
set /p sitename="Enter folder name: " %=%

set /p domainname="Enter your desired local domain name (.local will be added automatically): " %=%

::IF EXIST %BASEURL%%sitename% echo The specified site folder already exists! Choose another.
::IF EXIST %BASEURL%%sitename% goto sitenameprompt

IF NOT EXIST %BASEURL%%sitename% echo Creating folder
IF NOT EXIST %BASEURL%%sitename% MD %BASEURL%%sitename%

echo Adding virtualhost to httpd.conf
@echo off
(
echo:
echo:
echo    ###%domainname%.%SUFFIX%###
echo    ^<VirtualHost %domainname%.%SUFFIX%:80^>
echo        ServerAdmin admin@%domainname%.%SUFFIX%
echo        DocumentRoot "%BASEURL%%sitename%"
echo        ServerName %domainname%.%SUFFIX%
echo        ServerAlias %domainname%.%SUFFIX%
echo        ^<Directory "%BASEURL%%sitename%"^>
echo            Options Indexes FollowSymLinks Includes ExecCGI
echo            AllowOverride All
echo            Order allow,deny
echo            Allow from all
echo            Require all granted
echo        ^</Directory^>
echo    ^</VirtualHost^>
echo    ^<VirtualHost *:443^>
echo        SSLEngine on
echo        SSLCertificateFile conf/ssl.crt/server.crt
echo        SSLCertificateKeyFile conf/ssl.key/server.key
echo        DocumentRoot "%BASEURL%%sitename%"
echo        ServerName %domainname%.%SUFFIX%
echo        ServerAlias %domainname%.%SUFFIX%
echo        ^<IfModule alias_module^>
echo            ScriptAlias /cgi-bin/ "%BASEURL%%sitename%/cgi-bin/"
echo        ^</IfModule^>
echo    ^</VirtualHost^>
) >>%XAMPPDIR%apache\conf\extra\httpd-vhosts.conf
pause
echo Write into hosts file
type "%SystemRoot%\system32\drivers\etc\hosts" | find "127.0.0.1 %domainname%.%SUFFIX%" ||echo.127.0.0.1 %domainname%.%SUFFIX%>>"%SystemRoot%\system32\drivers\etc\hosts"
pause
echo Restarting apache
%XAMPPDIR%apache\bin\httpd -k restart
