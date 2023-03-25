#!/bin/bash
#
# Title:      Reference Title File - PGBlitz
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

### NOTE TO DELETE KEYS THAT EXIST WHEN BACKING UP
keybackup () {

serverid=$(cat /opt/var/pg.serverid)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Backing Up to GDrive - $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Standby, takes a minute!

EOF
gclone purge --config /opt/rclone/blitz.conf gd:/plexguide/backup/keys/$serverid
gclone copy --config /opt/rclone/blitz.conf /opt/rclone/blitz.conf gd:/plexguide/backup/keys/$serverid/conf -v --checksum --drive-chunk-size=64M
gclone copy --config /opt/rclone/blitz.conf /opt/var/keys/processed/ gd:/plexguide/backup/keys/$serverid/keys -v --checksum --drive-chunk-size=64M

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Backup Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
}

keyrestore () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Standby! Conducting Key Restore Check!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
gclone lsd --config /opt/rclone/blitz.conf gd:/plexguide/backup/keys/ | awk '{ print $5 }' > /tmp/service.keys
checkcheck=$(cat /tmp/service.keys)

if [ "$checkcheck" == "" ];then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Either You Failed to Configure RClone with GDrive or No Backups Exist!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  keymenu
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Type the Name of the Backup to Restore
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Quit? Type > exit

EOF
cat /tmp/service.keys

echo
read -p '🌍 Type Name | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "exit" ]; then keymenu; fi

grepcheck=$(cat /tmp/service.keys | grep $typed)
if [ "$grepcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Failed to Type Name of a Backup on the list! Restarting process!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
keyrestore; fi

serverid="$typed"
mkdir -p /opt/var/processed

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Restoring Keys - $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
gclone copy --config /opt/rclone/blitz.conf gd:/plexguide/backup/keys/$serverid/conf /opt/var/  -v --checksum --drive-chunk-size=64M
gclone copy --config /opt/rclone/blitz.conf gd:/plexguide/backup/keys/$serverid/keys /opt/var/keys/processed/  -v --checksum --drive-chunk-size=64M

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Key Restoration Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: When conducting a restore, no need to share out emails and etc! Just
redeploy PGBlitz!

EOF
read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
keymenu
}
