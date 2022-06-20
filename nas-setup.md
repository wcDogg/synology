# Synoloyg DS920+ with DSM 7

* https://www.youtube.com/watch?v=MyQy4Wj679A&t=24s
* https://www.wundertech.net/synology-nas-initial-setup-ultimate-guide


## Connections

1. NAS to Router
2. NAS to UPS

## Static IP

1. Fios > Network Settings > IPv4 Address Distribution > Connection List.
2. Device > Edit > Static Lease Type checkbox.

## Synology Account

1. Create a Synology account prior to starting.

## Default Ports

Some steps suggest changing the default ports. Other steps require defining a port. See [README: Ports](README.md/#ports).

## Initial

https://www.youtube.com/watch?v=6ZyC2nx65j8

1. In a browser, go to: https://find.synology.com
2. Verify info & click **Connect** - IP should match static assigned in previous step.
3. Accept User Agreement. **Next**.
4. Review Privacy Statement. **Continue**.
5. Web Assistant loads. **Setup**.
6. Install DSM. Takes about 10 minutes. NAS will beep during.

## DSM 7.1

1. Welcom screen loads. **Start**.
2. Create device name + admin account.
3. Update option = Automatically install important...
4. Optional: Sign in to Synology account.
5. Skp Quick Connect.
6. Other Tools: enable both Active Insights and DSM Configuration Backup.
7. Create a Storage Pool & Volume.
   1. Create Pool = MainPool
   2. RAID = SHR because we'll be adding drives in the future.
   3. Select both drives.
   4. Perform drive check.
   5. Create Volumne = MainVolume. Use BTFS file system.
   1. Confirm and Apply. Wait for the Pool + Volume to finish optimizing - about 90 minutes.

## Shared Folder

1. DSM > Control Panel > Shared Folder.
2. Set Name, Description, permissions.

## Home Services

1. Control Panel > User & Group > User Home - enable service.
2. Control Panel > Shared Folder > homes > Edit.
3. Check: Hide sub-folders from users without permissions.
4. Check: Enable Recycle Bin. 

## Data Scurbbing Schedule

1. DSM > Storage Manager
2. In the left panel, select a storage pool.
3. Select the Schedule Data Scrubbing tab.
4. On the next screen, select the pool and frequency.

## Snapshots

https://www.youtube.com/watch?v=mStoaZjJhJE

1. DSM > Package Center > install Snapshot Replication.
2. Enable daily snapshots.
3. Set 14 day retention policy.

## Recycle Bin

1. DSM > Control Panel > Task Scheduler.
2. Create > Schedule Task > Recycle Bin.
3. Schedule tab > Set daily.
4. Task Setting tab > Empty all Recycle Bins.
5. Task Setting tab > Retention Policy = 30 days.

## Storage Analyzer

https://youtu.be/MyQy4Wj679A?t=534

1. DSM > Control Panel > Shared Folder. Create a new directory to store reports.
1. DSM > Package Center > Install Storage Analyzer.
2. See video for step-by-step.

## UPS

1. Connect NAS to UPS using the provided USB cable.
2. DSM > Control Panel > Hardware & Power > UPS tab.
3. Enable support.
4. Select USB USP.
5. Customize Time = 5 minutes.

## Notifications

https://www.youtube.com/watch?v=wXCYEby3FJ8

## Security

https://www.youtube.com/watch?v=MISc_uqf0Q4

1. Auto-Update: Control Panel > Update & Restore. Select the recommended option.
2. Change default ports: Control Panel > Login Portal. 
   1. Change ports to something like 6049 and 6050.
   2. Check box: Auto redirect to HTTPS.
3. DoS Protection: Control Panel > Security > Protection tab. Enable DOS protection. Enable Auto-Block. Whitelist IP addresses.

## 2FA

https://www.youtube.com/watch?v=r3adGcCjr2M

1. 2FA: DSM > User icon (upper-right) > Account tab. 

## Firewall

https://www.youtube.com/watch?v=G3BJo4B1GgU&t=0s

