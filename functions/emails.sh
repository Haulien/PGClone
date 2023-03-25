#!/bin/bash
#
# Title:      Reference Title File - PGBlitz
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
emailgen () {

rm -rf /opt/var/.emailbuildlist 1>/dev/null 2>&1
rm -rf /opt/var/.emaillist  1>/dev/null 2>&1

ls -la /opt/var/.blitzkeys | awk '{print $9}' | tail -n +4 > /opt/var/.emailbuildlist
while read p; do
  cat /opt/var/.blitzkeys/$p | grep client_email | awk '{print $2}' | sed 's/"//g' | sed 's/,//g' >> /opt/var/.emaillist
done </opt/var/.emailbuildlist

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 EMail Share Generator ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PURPOSE: Share out the service accounts for the TeamDrives. Failing to do
so will result in PGBlitz Failing!

Shortcut to Google Team Drives >>> td.pgblitz.com

NOTE 1: Share the E-Mails with the CORRECT TEAMDRIVE: $sdname
NOTE 2: SAVE TIME! Copy & Paste the all the E-Mails into the share!"

EOF
cat /opt/var/.emaillist
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -rp '↘️  Completed? | Press [ENTER] ' typed < /dev/tty
clonestart

}
