# name.com_updater
Quick dirty script to update my DNS record on name.com

Usage:

`bash change.sh`

Make a systemd or pm2 service to use it as a daemon.
If you want to use it for yourself, you'll have to replace the domain names with your own too


## How it works:
Gets your public ip by making a HTTP GET to ifconfig.me and updates the dns record using name.come HTTP API
