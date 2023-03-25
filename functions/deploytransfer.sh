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
executetransport () {

# Reset Front Display
rm -rf  /opt/rclone/deployed.version

# Call Variables
pgclonevars

# to remove all service running prior to ensure a clean launch
ansible-playbook /opt/pgclone/ymls/remove.yml

########################################################### GDRIVE START
echo "gd" > /opt/rclone/deployed.version
type=gd
ansible-playbook /opt/pgclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gd"
########################################################### GDRIVE END

########################################################### SDRIVE END
if [[ "$transport" == "gc" || "$transport" == "sc" || "$transport" == "sd" ]]; then
type=sd
echo "sd" > /opt/rclone/deployed.version
encryptbit=""
ansible-playbook /opt/pgclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  cm="writes"
  drive=sd"
fi
########################################################### SDRIVE END

########################################################### ENCRYTPION START
if [[ "$transport" == "gc" || "$transport" == "sc" ]]; then
echo "gc" > /opt/rclone/deployed.version
type=gc
ansible-playbook /opt/pgclone/ymls/crypt.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gc"
fi

if [[ "$transport" == "sc" ]]; then
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
########################################################### ENCRYTPION END

# builds the list
if [[ "$transport" == "sd" || "$transport" == "sc" ]]; then
  ls -la /opt/var/.blitzkeys/ | awk '{print $9}' | tail -n +4 | sort | uniq > /opt/var/.blitzlist
  rm -rf /opt/var/.blitzfinal 1>/dev/null 2>&1
  touch /opt/var/.blitzbuild
  while read p; do
    echo $p > /opt/var/.blitztemp
    blitzcheck=$(grep "GDSA" /opt/var/.blitztemp)
    if [[ "$blitzcheck" != "" ]]; then echo $p >> /opt/var/.blitzfinal; fi
  done </opt/var/.blitzlist
fi

# deploy union
ansible-playbook /opt/pgclone/ymls/pgunity.yml -e "\
  transport=$transport
  encryptbit=$encryptbit
  multihds=$multihds
  type=$type
  dcs=$dcs
  hdpath=$hdpath"

# output final display
if [[ "$type" == "gd" ]]; then finaldeployoutput="GDrive Unencrypted"
elif [[ "$type" == "gc" ]]; then finaldeployoutput="GDrive Encrypted"
elif [[ "$type" == "sd" ]]; then finaldeployoutput="SDrive Unencrypted"
elif [[ "$type" == "sc" ]]; then finaldeployoutput="SDrive Encrypted"; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 DEPLOYED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

}
