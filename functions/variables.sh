#!/bin/bash
#
# Title:      Reference Title File - PGBlitz
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
pgclonevars () {

  variablet () {
    file="$1"
    if [ ! -e "$file" ]; then touch "$1"; fi
  }

  # rest standard
  mkdir -p /opt/logs /opt/rclone
  touch /opt/logs/gd.log /opt/logs/sd.log /opt/logs/ge.log /opt/logs/se.log /opt/logs/pgblitz.log /opt/logs/transport.log

  variable /opt/var/project.account "NOT-SET"
  variable /opt/rclone/deploy.version "null"
  variable /opt/rclone/pgclone.transport "NOT-SET"
  variable /opt/var/move.bw  "9"
  variable /opt/var/blitz.bw  "1000"
  variable /opt/rclone/pgclone.salt ""
  variable /opt/var/multihd.paths ""

  variable /opt/var/server.hd.path "/pg"
  hdpath=$(cat /opt/var/server.hd.path)

  variable /opt/rclone/oauth.check ""
  oauthcheck=$(cat /opt/rclone/oauth.check)

  variable /opt/rclone/pgclone.password "NOT-SET"
  if [[ $(cat /opt/rclone/pgclone.password) == "NOT-SET" ]]; then pstatus="NOT-SET"
  else
    pstatus="ACTIVE"
    clonepassword=$(cat /opt/rclone/pgclone.password)
    clonesalt=$(cat /opt/rclone/pgclone.salt)
  fi

  variable /opt/rclone/.gd "NOT-SET"
  if [[ $(cat /opt/rclone/.gd) == "NOT-SET" ]]; then gdstatus="NOT-SET"
  else gdstatus="ACTIVE"; fi

  variable /opt/rclone/.sd "NOT-SET"
  if [[ $(cat /opt/rclone/.sd) == "NOT-SET" ]]; then sdstatus="NOT-SET"
  else sdstatus="ACTIVE"; fi

  variable /opt/rclone/.sc "NOT-SET"
  if [[ $(cat /opt/rclone/.sc) == "NOT-SET" ]]; then scstatus="NOT-SET"
  else scstatus="ACTIVE"; fi

  variable /opt/rclone/.gc "NOT-SET"
  if [[ $(cat /opt/rclone/.gc) == "NOT-SET" ]]; then gcstatus="NOT-SET"
  else gcstatus="ACTIVE"; fi

  transport=$(cat /opt/rclone/pgclone.transport)

  variable /opt/rclone/pgclone.teamdrive "NOT-SET"
  sdname=$(cat /opt/rclone/pgclone.teamdrive)

  variable /opt/rclone/pgclone.demo "OFF"
  demo=$(cat /opt/rclone/pgclone.demo)

  variable /opt/rclone/pgclone.teamid ""
  sdid=$(cat /opt/rclone/pgclone.teamid)

  variable /opt/rclone/deploy.version ""
  type=$(cat /opt/rclone/deploy.version)

  variable /opt/rclone/pgclone.public ""
  pgclonepublic=$(cat /opt/rclone/pgclone.public)

  mkdir -p /opt/var/.blitzkeys
  displaykey=$(ls /opt/var/.blitzkeys | wc -l)

  variable /opt/rclone/pgclone.secret ""
  pgclonesecret=$(cat /opt/rclone/pgclone.secret)

  if [[ "$pgclonesecret" == "" || "$pgclonepublic" == "" ]]; then pgcloneid="NOT-SET"; fi
  if [[ "$pgclonesecret" != "" && "$pgclonepublic" != "" ]]; then pgcloneid="ACTIVE"; fi

  variable /opt/rclone/pgclone.email "NOT-SET"
  pgcloneemail=$(cat /opt/rclone/pgclone.email)

  variable /opt/var/oauth.type "NOT-SET" #output for auth type
  oauthtype=$(cat /opt/var/oauth.type)

  variable /opt/rclone/pgclone.project "NOT-SET"
  pgcloneproject=$(cat /opt/rclone/pgclone.project)

  variable /opt/rclone/deployed.version ""
  dversion=$(cat /opt/rclone/deployed.version)

  variablet /opt/var/.tmp.multihd
  multihds=$(cat /opt/var/.tmp.multihd)

  if [[ "$dversion" == "gd" ]]; then dversionoutput="GDrive Unencrypted"
elif [[ "$dversion" == "gc" ]]; then dversionoutput="GDrive Encrypted"
elif [[ "$dversion" == "sd" ]]; then dversionoutput="SDrive Unencrypted"
elif [[ "$dversion" == "sc" ]]; then dversionoutput="SDrive Encrypted"
elif [[ "$dversion" == "le" ]]; then dversionoutput="Local HD/Mount"
else dversionoutput="None"; fi

# For Clone Clean
  variable /opt/var/cloneclean "600"
  cloneclean=$(cat /opt/var/cloneclean)

# Copy JSON if Missing
  if [ ! -e "/opt/rclone/pgclone.json" ]; then cp /opt/pgclone/pgclone.json /opt/rclone/pgclone.json; fi

# For PG Blitz Mounts
  bs=$(jq -r '.bs' /opt/rclone/pgclone.json)
  dcs=$(jq -r '.dcs' /opt/rclone/pgclone.json)
  dct=$(jq -r '.dct' /opt/rclone/pgclone.json)
  cma=$(jq -r '.cma' /opt/rclone/pgclone.json)
  rcs=$(jq -r '.rcs' /opt/rclone/pgclone.json)
  rcsl=$(jq -r '.rcsl' /opt/rclone/pgclone.json)
  cm=$(jq -r '.cm' /opt/rclone/pgclone.json)
  cms=$(jq -r '.cms' /opt/rclone/pgclone.json)

  randomagent=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
  variable /opt/var/uagent "$randomagent"
  uagent=$(cat /opt/var/uagent)
}
