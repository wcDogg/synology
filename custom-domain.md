# NAS Custom Domain

DDNS maps a dynamically assigned IP address - like those on most routers - to a domain name.

Big idea: First set things up using the Synology service provider + Lets Encrypt SSL certificate. Then migrate to custom domain. 

## Synology Service

* [Wundertech: How to Access a Synology NAS Remotely with DDNS](https://www.wundertech.net/how-to-access-a-synology-nas-remotely/)

Currently, we have customized the DSM login portal and enabled auto-redirect to HTTPS. Even so, the connection is made over `http` and shows as not secure. Hypothisis is that completing these steps, specifically adding an SSL certificate, will allow `https`.

* DSM > Security > Firewall > currently disabled 
* DSM > Login Portal > DSM tab > enabled Auto-redirect to HTTPS for DSM Desktop
* DSM > Security > Security tab > enabled HTTP Content Security Policy (CSP)

Steps:

1. DSM > Control Panel > External Access > DDNS tab > Add
2. Service Provider = Synology
3. Hostename = wcds.synology.me
4. External Address (IPv4) + (IPv6) = Auto
5. Get certificate from Let's Encrypt = True
6. Enable Heartbeat = True
7. Test Connection
8. Apply and wait for webservice to restart
9. DSM > Control Panel > Security > Certificate > Settings

