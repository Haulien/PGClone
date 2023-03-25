#!/bin/bash
#
# Title:      Reference Title File - PGBlitz
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
# NOTES
# Variable recall comes from /functions/variables.sh
################################################################################
executeblitz () {

# Reset Front Display
rm -rf plexguide/deployed.version

# Call Variables
pgclonevars

# to remove all service running prior to ensure a clean launch
ansible-playbook /opt/pgclone/ymls/remove.yml

# gdrive deploys by standard
type=gd
encryptbit=""
ansible-playbook /opt/pgclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gd"

type=sd
ansible-playbook /opt/pgclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  cm="writes"
  drive=sd"

# deploy only if gdrive is using encryption
if [[ "$transport" == "sc" ]]; then
type=gc
ansible-playbook /opt/pgclone/ymls/crypt.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gc"

echo "sc" > /opt/rclone/deployed.version
type=sc
encryptbit="C"
ansible-playbook /opt/pgclone/ymls/crypt.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=sc"
fi

# builds the list
ls -la /opt/var/.blitzkeys/ | awk '{print $9}' | tail -n +4 | sort | uniq > /opt/var/.blitzlist
rm -rf /opt/var/.blitzfinal 1>/dev/null 2>&1
touch /opt/var/.blitzbuild
while read p; do
  echo $p > /opt/var/.blitztemp
  blitzcheck=$(grep "GDSA" /opt/var/.blitztemp)
  if [[ "$blitzcheck" != "" ]]; then echo $p >> /opt/var/.blitzfinal; fi
done </opt/var/.blitzlist

# deploy union
ansible-playbook /opt/pgclone/ymls/pgunity.yml -e "\
  transport=$transport \
  type=$type
  multihds=$multihds
  encryptbit=$encryptbit
  dcs=$dcs
  hdpath=$hdpath"

# output final display
if [[ "$type" == "sd" ]]; then finaldeployoutput="SDrive Unencrypted"
else finaldeployoutput="SDrive Encrypted"; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 DEPLOYED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

}
