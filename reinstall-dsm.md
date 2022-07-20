# Reinstall DSM 7

Scenario: We accidentally SSHed a Go language directory into an apparently restricted area of the NAS. The process raised security alerts and seemed to trigger a cascade of failures we can't recover from. 

RAID: We have 2 drives using SHR - the Synology equivalent of RAID 1 (mirroring) with the ability to add drives in the future.

Data: In short, we need to preserve our data - while it's not a lot, what's there is important and irreplaceable. 

Goal: Reinstall DSM without losing data. 

## Synology Assistant

Download and install the [Synology Assistant app](https://www.synology.com/en-us/support/download) - it lets you connect to the NAS without going through DSM. 

## Back Up NAS Config

* https://www.howtogeek.com/318693/how-to-back-up-and-restore-your-synology-nas-configuration/
* DSM > Control Panel > Update & Restore > Configuration Backup > Manual Export




