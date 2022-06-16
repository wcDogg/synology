# SSH to Synology NAS


## SSH with Password

* https://www.youtube.com/watch?v=BCCIMRbAUp8

1. Control Panel > Terminal & SNMP > Terminal tab.
2. Enable SSH service and set a random port. (49200)
3. Control Panel > Security > Firewall tab.
4. Default profile > Edit Rules link.
5. Firewall Rules > Create > Ports > Select from list of apps.
6. Check box: Encrypted Terminal Services (SSH).

It's rare to need SSH, but when you do, it's usually to do something as `root`. To get there:

```
ssh username@192.x.x.xxx -p49200
password
sudo -i
password
```

## SSH with Key 

Prerequisites:

* Windows + PowerShell SSH setup
* Synology Home Services enabled
* Synology SSH enabled 
* User is an Admin and can SSH with password

### NAS

```
# SSH to user's home directory

# Make .ssh directory
mkdir .ssh

# Make authorized_keys file
touch .ssh/authorized_keys

# Change home dir permissions to drwx------
chmod 700

# Change .ssh dir permissions to drwx------
chmod 700 .ssh

# Change authorized_keys file permissions to -rw-------
chmod 600 .ssh/authorized_keys

# Edit /etc/ssh/sshd_config
sudo vim /etc/ssh/sshd_config
password

# Uncomment: "PubkeyAuthentication yes"
# Uncomment: "AuthorizedKeysFile .ssh/authorized_keys"
# Uncomment: "ChallengeResponseAuthentication no"

# Save file
# Esc to return to command mode
:wq
```

2. DSM > Control Panel > Terminal & SNMP. Disable SSH + Apply. Enable SSH + Apply.

## Windows

Big idea: Create a keypair, place into the Windows Security context, copy public key to NAS. 

These instructions are similar to those we documented in: [openSSH](https://github.com/CornDoggSoup/windows/blob/main/windows-11-pro-openSSH.md).

IMPORTANT: This will be our second key and the process for deploying the public key - specifically the step involving `C:\ProgramData\ssh\administrators_authorized_keys` - is different. 

Terminal 1:
```
# Log in to SSH server
ssh wcd@wcdPC

# Generate 4096 bit key of type rsa
# Save path = C:\Users\wcd/.ssh/id_wcd_4096.pub
ssh-keygen -t rsa -b 4096
```

Terminal 2:
```
# Add private key to Windows security context

Get-Service ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
Get-Service ssh-agent
ssh-add C:\Users\wcd\.ssh\id_wcd_4096
```


# Deploy Public key
# Windows account passowrd
# This add 


```
