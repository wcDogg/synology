# SSH to Synology NAS

Note that SSH access should only be permitted as-needed and blocked the rest of the time. The way we're configured, the simplest way to toggle access is via its Synology firewall rule. 

## Enable SSH

1. DSM > Control Panel > Terminal & SNMP > Terminal tab
   1. Enable SSH Service = True/checked
   2. Port = 49200
   3. Apply
2. DSM Control Panel > Security > Firewall tab
   1. Firewall Profile > default > Edit Rules button - dialog opens
   2. Firewall Rules > Create > Ports > Custom = 49200/TCP
   3. OK
   4. Ensure the Deny All rule is at bottom
   
   
## SSH with Password

```powershell
ssh wcdogg@192.168.1.209 -p49200 
password
```

## SSH with Key 

Big idea: Create a key pair, place private key into the Windows Security context, copy public key to NAS. Prerequisites:

* Windows [SSH is configured](https://github.com/wcDogg/windows/blob/main/openSSH.md)
* Synology Home Services enabled
* Synology SSH enabled 
* User is an Admin and can SSH with password


## Windows: Backup `authorized_keys` file

```powershell
# PowerShell as admin
Copy-Item "C:\ProgramData\ssh\administrators_authorized_keys" -Destination "C:\ProgramData\ssh\old_administrators_authorized_keys"

# Restore (in case of mistake)
Copy-Item "C:\ProgramData\ssh\old_administrators_authorized_keys" -Destination "C:\ProgramData\ssh\administrators_authorized_keys"
```

## Windows: Generate Key Pair

Synology requires an RSA key with 4096 bits - this is not the default.

```powershell
# Log in to SSH server
ssh wcd@wcdPC

# Generate 4096 bit key of type rsa
ssh-keygen -t rsa -b 4096

# Save path = C:\Users\wcd/.ssh/wcd_nas_rsa4096
# Passphrase = none
# Copy SHA256 fingerprint to password manager
```

## Windows: Add Private Key to Windows Security Context

In a second PowerShell as admin:

```powershell
# If needed, start SSH Agent
# I have this in my PS profile so it auto-starts
Get-Service ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
Get-Service ssh-agent

# Add private key to Windows security context
ssh-add C:\Users\wcd\.ssh\wcd_nas_rsa4096

# Append public key to authorized_keys
cat C:\Users\wcd\.ssh\wcd_nas_rsa4096.pub >> C:\ProgramData\ssh\administrators_authorized_keys

# At this point you can delete the private key
# Leave public key in C:\Users\wcd\.ssh
```

## NAS: Create .ssh Directory and authorized_keys File

```powershell
# SSH with password to NAS
ssh wcdogg@192.168.1.209 -p49200

# SSH drops you into your home directory - confirm
pwd
# Or you can cd there with either of these
cd /volume1/homes/wcdogg
cd /var/services/homes/wcdogg

# Create .ssh directory if it doesn't exist
mkdir -p .ssh

# Create an authorized_keys file if it doesn't exist
cd .ssh
ls -la
touch authorized_keys

# Back up to home
cd ..

# Change home dir permissions to drwx------
chmod 700 .

# Change .ssh dir permissions to drwx------
chmod 700 .ssh

# Change authorized_keys file permissions to -rw-------
chmod 600 .ssh/authorized_keys
```

## Copy Public key from Windows to NAS

In a separate PowerShell not SSHed to NAS: 

```powershell
# Note the lowercase drive and reversed slashes in Windows path
# Requires NAS password
scp -P 49200 c:/Users/wcd/.ssh/wcd_nas_rsa4096.pub wcdogg@wcdNAS:/volume1/homes/wcdogg/.ssh/
```

## Append Public to authorized_keys

In original PowerShell that's SSHed to NAS: 

```powershell
# Append key
cd .ssh
cat wcd_nas_rsa4096.pub >> authorized_keys

# View file
cat authorized_keys
```

## Configure NAS

One-time edit of `/etc/ssh/sshd_config`. 

```powershell
# Edit this file
# Last time we need NAS password :)
sudo vim /etc/ssh/sshd_config
password
i  # Insert mode

# Uncomment these lines
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
ChallengeResponseAuthentication no

# Change this line to NO
PasswordAuthentication no

# Save file
Esc  # return to command mode
:wq

# View file
sudo cat /etc/ssh/sshd_config
```

## Restart SSH and Test

1. DSM > Control Panel > Terminal & SNMP > Terminal tab
   1. Disable SSH + Apply 
   2. Enable SSH + Apply

```powershell
# SSH as usual - no password :)
ssh wcdogg@192.168.1.209 -p49200
```

## PowerShell Profile

Add this to your user profile - and not the global profile.

```ps1
# SSH to NAS
function NAS {ssh wcdogg@192.168.1.209 -p49200}

# Now you can SSH with this command
NAS
```
