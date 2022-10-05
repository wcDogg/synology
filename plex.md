# Install Plex Media Server on Synology NAS

## Create a Shared Folder

1. DSM > Control Panel > Shared Folder
2. Create > Shared Folder
3. Name = Plex
4. Description = Media Server
5. Hide this shared folder = False
6. Hide sub-folders = False
7. Enable Recycle Bin = True
8. Restrict to admins only = False
9.  Encrypt this shared folder = False
10. Enable data checksum = False
11. Enable shared folder quota = False
12. User permissions - Check the Read/Write option for both the admin account and your current account.  


## Drag-Drop Media

1. DSM > File Station 
2. Plex > Settings button
3. Enable Smart Drag and Drop = True / Skp
4. Save


## Firewall

Temporarily open port 32400 TCP on NAS firewall - changed later from Plex's advanced settings.


## Install Plex

1. DSM > Package Center
2. Search for Plex 
3. Click the Join Beta button - a dialog opens. Accept the terms.
4. Click Join Beta again - starts Install
5. Shared Folder Path = /volume1/Plex
6. Confirm settings + click Done


## Add Folder Permissions

1. DSM > Control Panel > Shared Folder
2. Plex > Edit 
3. Permissions tab > change dropdown to System Internal User
4. Check the Read/Write option for Plex
5. Save


## Launch Plex

1. DSM > Package Center > Plex > Open
2. A new tab opens with an overview of Plex - click Got It
3. An offer for Plex Pass opens - close out of it
4. Server Setup
   1. Name = wcdPLEX
   2. Add Library = Follow prompts to select media types and folders
   3. Done
5. The main UI loads. In the upper-right, either Sign In or Sign Up
6. Expand the left panel > More > click into one of your media folders
7. Follow prompts to claim server

Plex is also available at http://192.168.1.209:32400


## TODO Change the Default Port

1. Plex > User > Account
2. Left menu > Settings > Remote Access > Show Advanced
3. Manually specify public port = True
4. Port = 7032
5. Apply


## TODO Install Updates

TODO


## References

* https://www.youtube.com/watch?v=XUXJFu1LtJ4

