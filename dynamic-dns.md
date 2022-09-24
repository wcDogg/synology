# Dynamic DNS

Most home routers are assigned a dynamic IP address - meaning it can change at any time. There are several options for automatically informing Cloudflare when the router's IP changes. I'm doing this by running a Docker container on the NAS.

## Cloudflare API Token

1. Log in to Cloudflare
2. User menu > My Profile
3. Left menu > API tokens
4. Create Token using the Read All Resources template
5. Limit Zone Resources to site.com
6. Continue to Summary. Create Token.
7. Copy token to a password manager
8. Use the on-screen command to test (remove \s)




## References

* [Cloudflare: Use Dynamic IP Addresses](https://developers.cloudflare.com/dns/manage-dns-records/how-to/managing-dynamic-ip-addresses/)
* https://www.youtube.com/watch?v=Nf7m3h11y-s


