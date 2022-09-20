# Reinstall DSM 7

## Scenario

We accidentally SSHed a Go language directory into an apparently restricted area of the NAS. The process raised security alerts and seemed to trigger a cascade of failures we can't recover from. 

RAID: We have 2 drives using SHR - the Synology equivalent of RAID 1 (mirroring) with the ability to add drives in the future.

Data: In short, we need to preserve our data - while it's not a lot, what's there is important and irreplaceable. 

Goal: Reinstall DSM without losing data. 


## Synology Assistant

Download and install the [Synology Assistant app](https://www.synology.com/en-us/support/download) - it lets you connect to the NAS without going through DSM. 


## Back Up NAS Config

1. DSM > Control Panel 
2. Update & Restore > Configuration Backup > Manual Export


## SSH Files while Connected to NAS

Here's how I transferred the photos back to my PC. 

```powershell
NAS
cd /volume1/photo
ls -la

scp -r "2004 Christmas" wcd@192.168.1.208:d:/Photos
```

## Reset NAS

1. Press and hold Reset button for 5 seconds - beep.
2. Repeat - several beeps.
3. Wait for Status light to blink orange.
4. In a browser, go to: https://find.synology.com.
5. Accept the terms.
6. Click Reinstall (DSM) and follow prompts.

