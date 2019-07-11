# FileZillaConfigAnalyse
A PowerShell-Script to export die Config File

This script allows to analyze the Filezilla Sitemanager XML configuration file and shows the following Output:

Name     : FTPserver
Host     : ftp.FTPserver.de
Port     : 21
Username : User
Password : plaintextpassword


for each configured server in the Sitemanager xml file, where these information are stored.
It also decrypts the stored password (Base64).

At first there is a check if the Filezilla application in version 3.X is installed.
If the Sitemanager.xml is not stored in the defaultpath [%Appdata%\Filezilla], the script will analyze the Filezilla configuration file 
fzdefaults.xml. 
This configuration file contains the alernative Sitemanager.xml path which is stored in the programmfiles directory.
After passing all of the checks the script generates the output above.

Next steps:
- Warp the whole script into a function
- Write a detailed .SYNOPSIS

Tested on:
Windows 10
Windows Server 2012
Windows Server 2008

Tested Version:
Filzilla 3.X
