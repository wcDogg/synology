# Synology DS920+ with DSM 7 Setup


## Physical Connections

1. NAS to router / ethernet
2. NAS to UPS / power cable
3. NAS to UPS / USB cable


## Static IP

Assign NAS a static IP address on your router. I have a Fios G3100. For me the steps are:

1. Log in to the router.
2. Switch to the Advanced tab.
3. Network Settings > IPv4 Address Distribution
4. SynologyNAS > Edit
5. Static Lease Type = True / checked


## Synology Account

Create a Synology account prior to starting.

* https://www.synology.com/en-us


## Locate NAS & Install DSM

1. In a browser, go to: https://find.synology.com
2. Verify info & click **Connect** - IP should match static assigned in previous step.
3. Accept User Agreement. **Next**.
4. Review Privacy Statement. **Continue**.
5. Web Assistant loads. **Setup**.
6. Install DSM. Takes about 10 minutes. NAS will beep during.


## DSM 7.1

1. Welcome screen loads. **Start**.
2. Create device name + admin account.
3. Update option = Automatically install important...
4. Optional: Sign in to Synology account.
5. Skip Quick Connect.
6. Other Tools: enable both Active Insights and DSM Configuration Backup.
7. Create a Storage Pool & Volume.
   1. Create Pool = MainPool
   2. RAID = SHR because we'll be adding drives in the future.
   3. Select both drives.
   4. Perform drive check.
   5. Create Volume = MainVolume. Use BTFS file system.
   1. Confirm and Apply. Wait for the Pool + Volume to finish optimizing - about 90 minutes.


## Shared Folder

1. DSM > Control Panel > Shared Folder.
2. Set name, description, permissions.


## Home Services

1. Control Panel > User & Group > Advanced tab 
   1. Enable user home service = True/checked
   2. Apply
2. Control Panel > Shared Folder 
   1. homes > Edit 
   2. Hide sub-folders from users without permissions = True/checked
   3. Enable Recycle Bin = True/checked
   4. Save


## Data Scrubbing Schedule

1. DSM > Storage Manager
2. In the left panel, select a storage pool - Storage Pool 1.
3. Select the Schedule Data Scrubbing tab - a dialog opens.
4. Enable data scrubbing schedule = True/checked
5. The correct pool should already be selected.
6. Frequency = Repeat Monthly
7. Optional - Run data scrubbing only during specific periods
8. Save


## Snapshots

1. DSM > Storage Manager
   1. In the left panel, select a volume - Volume 1
   2. On the main screen, in the Volume 1 section, click the *** menu > Settings
   3. Record File Access Time Frequency = Never
   4. Save
2. DSM > Package Center
   1. Install Snapshot Replication and open app
   2. In the left panel, select Snapshots
   3. Click the Settings button
   4. Schedule tab
      1. Enable Snapshot Schedule = True/checked
      2. Set a schedule that's appropriate
   5. Retention tab
      1. Enable Retention Policy = True/checked
      2. Keep all snapshots for = 7 days
   6. OK


## Recycle Bin

1. DSM > Control Panel > Task Scheduler
2. Create > Schedule Task > Recycle Bin
3. General tab
   1. Task Name = Empty recycle bins
   2. Enabled = True/checked
4. Schedule tab
   1. Run on the following days = Daily
   2. Frequency = Every day
5. Task Setting tab 
   1. Empty all Recycle Bins = True
   2. Number of days to retain deleted files = 7
6. OK


## Storage Analyzer

1. DSM > Control Panel > Shared Folder. Create a new directory to store reports.
1. DSM > Package Center > Install Storage Analyzer.
2. See video for step-by-step: https://youtu.be/MyQy4Wj679A?t=534


## UPS

1. Connect NAS to UPS using the provided USB cable.
2. DSM > Control Panel > Hardware & Power > UPS tab
3. Enable UPS Support = True/checked
4. UPS Type = USB USP
5. Customize Time = 5 minutes
6. Apply


## Security

1. DSM > Control Panel > Update & Restore > DSM Update tab
   1. Click Update Settings - a dialog opens
   2. Select an update option - I selected the recommended option
   3. Set a Check Schedule
   4. OK
3. DSM > Control Panel > Security > Protection tab
   1. Enable Auto-Block = True/checked
      1. Login Attempts = 10
      2. Within Minutes = 5
   2. Enable Block Expiration = True/checked
      1. Unlock After Days = 1
   3. Enable DoS Protection = True/checked
   4. Apply


## 2FA

1. DSM > User menu (upper-right) > Personal > Account tab
2. Sign-in Method = 2 Factor Authentication
3. Follow prompts


## Web UI

1. DSM > Control Panel > Login Portal > DSM tab
2. Change DSM Port (HTTP) to 6049
3. Change DSM Port (HTTPS) to 6050
4. Automatically redirect HTTP to HTTPS = True
5. Save


## Firewall

These are the temporary rules needed during configuration - [Initial Firewall Rules](network.md/#initial-firewall-rules).


## Sign In to Web UI

At this point you should be able to reach the DSM web UI at the NAS's static IP address at port 6049 (http).

* http://192.168.1.209:6049


## Notifications

https://www.youtube.com/watch?v=wXCYEby3FJ8


## References

* https://www.youtube.com/watch?v=MyQy4Wj679A&t=24s
* https://www.wundertech.net/synology-nas-initial-setup-ultimate-guide
* https://www.youtube.com/watch?v=mStoaZjJhJE
* https://www.youtube.com/watch?v=G3BJo4B1GgU&t=0s
* https://www.youtube.com/watch?v=MISc_uqf0Q4

