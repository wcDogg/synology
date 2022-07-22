# SSH to Synology NAS

Note that SSH access should only be permitted as-needed and blocked the rest of the time. The way we're configured, the simplest way to toggle access is via its Synology firewall rule. 

## SSH with Password

https://www.youtube.com/watch?v=BCCIMRbAUp8

1. DSM > Control Panel > Terminal & SNMP > Terminal tab.
   1. Enable SSH service and set a random port. (49200)
2. Control Panel > Security > Firewall tab.
   1. Default profile > Edit Rules link.
   2. Firewall Rules > Create > Ports > Select from list of apps.
   3. Check box: Encrypted Terminal Services (SSH).

```
ssh nasuser@192.x.x.xxx -p49200
password

# escalate to root
sudo -i
password
```

## SSH with Key 

Big idea: Create a keypair, place into the Windows Security context, copy public key to NAS. Prerequisites:

* Windows + PowerShell SSH setup
* Synology Home Services enabled
* Synology SSH enabled 
* User is an Admin and can SSH with password

## Windows

These are shallow instructions. The detailed process is here: [openSSH](https://github.com/CornDoggSoup/windows/blob/main/windows-11-pro-openSSH.md).

IMPORTANT: This will be our second key. Be sure to append - and not overwrite -  `C:\ProgramData\ssh\administrators_authorized_keys`. 

### Backup `authorized_keys` file

```
Copy-Item "C:\ProgramData\ssh\administrators_authorized_keys" -Destination "C:\ProgramData\ssh\old_administrators_authorized_keys"
```

### Terminal 1 (same)

```
# Log in to SSH server

ssh me@myPC

# Generate 4096 bit key of type rsa
# Save path = C:\Users\me/.ssh/id_me_rsa4096

ssh-keygen -t rsa -b 4096
```

### Terminal 2 (same)
```
# Add private key to Windows security context.

Get-Service ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
Get-Service ssh-agent
ssh-add C:\Users\me\.ssh\id_me_rsa4096

# This is the different step.
# Append authorized_keya.

cat C:\Users\me\.ssh\id_me_rsa4096.pub >> C:\ProgramData\ssh\administrators_authorized_keys
```

## NAS

I found this easier to do from the NAS vs Powershell.

1. DSM > File Station > home 
2. Create .ssh directory
3. Upload public key and rename it `authorized_keys`. Note subsequent keys are appended to this file.

```
# Example of how to get:
# "D:\.ssh\id_madNAS_rsa4096.pub" to here:
# "/volume1/homes/msoup/.ssh/authorized_keys" >

scp -P 49200 d:/.ssh/id_madNAS_rsa4096.pub wcdogg@wcdNAS:/volume1/homes/msoup/.ssh/

NAS
cd /volume1/homes/msoup/.ssh/
ls

# Overwrite current authorized_keys files
cat id_madNAS_rsa4096.pub > authorized_keys

# Update permissions 
chmod 600 .ssh/authorized_keys

# View file
vim authorized_keys
:q
```

### Each User

```
# SSH to user's home directory

# Change home dir permissions to drwx------
chmod 700 .

# Change .ssh dir permissions to drwx------
chmod 700 .ssh

# Change authorized_keys file permissions to -rw-------
chmod 600 .ssh/authorized_keys
```

### NAS Config

One-time edit of `/etc/ssh/sshd_config`

```
sudo vim /etc/ssh/sshd_config
password

# Uncomment: "PubkeyAuthentication yes"
# Uncomment: "AuthorizedKeysFile .ssh/authorized_keys"
# Uncomment: "ChallengeResponseAuthentication no"

# Save file
# Esc to return to command mode
:wq
```

Restart SSH and test:

* DSM > Control Panel > Terminal & SNMP. Disable SSH + Apply. Enable SSH + Apply.
* Powershell > SSH no longer requires a password.

### PowerShell Profile

Add this to user's profile - and not the global profile.

```
# SSH to NAS
function NAS {ssh nasuser@192.xxx.x.xxx -p49200}
```

