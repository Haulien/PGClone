#!/bin/bash
#
# Title:      Reference Title File - PGBlitz
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
deploysdrive () {
  deployblitzstartcheck # At Bottom - Ensure Keys Are Made

# RCLONE BUILD
echo "#------------------------------------------" > /pg/rclone/blitz.conf
echo "#RClone Rewrite | Visit https://pgblitz.com" >> /pg/rclone/blitz.conf
echo "#------------------------------------------" >> /pg/rclone/blitz.conf

cat /pg/rclone/.gd >> /pg/rclone/blitz.conf

if [[ $(cat "/pg/rclone/.gc") != "NOT-SET" ]]; then
echo ""
cat /pg/rclone/.gc >> /pg/rclone/blitz.conf; fi

cat /pg/rclone/.sd >> /pg/rclone/blitz.conf

if [[ $(cat "/pg/rclone/.sc") != "NOT-SET" ]]; then
echo ""
cat /pg/rclone/.sc >> /pg/rclone/blitz.conf; fi

cat /pg/var/.keys >> /pg/rclone/blitz.conf

deploydrives
}

deploygdrive () {
# RCLONE BUILD
echo "#------------------------------------------" > /pg/rclone/blitz.conf
echo "#RClone Rewrite | Visit https://pgblitz.com" >> /pg/rclone/blitz.conf
echo "#------------------------------------------" >> /pg/rclone/blitz.conf

cat /pg/rclone/.gd > /pg/rclone/blitz.conf

if [[ $(cat "/pg/rclone/.gc") != "NOT-SET" ]]; then
echo ""
cat /pg/rclone/.gc >> /pg/rclone/blitz.conf; fi
deploydrives
}

deploydrives () {
  fail=0
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Conducting RClone Mount Checks ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

if [ -e "/pg/logs/.drivelog" ]; then rm -rf /pg/logs/.drivelog; fi
touch /pg/logs/.drivelog

  if [[ "$transport" = "gd" ]]; then
    gdrivemod
    multihdreadonly
  elif [[ "$transport" == "gc" ]]; then
    gdrivemod
    gcryptmod
    multihdreadonly
  elif [[ "$transport" == "sd" ]]; then
    gdrivemod
    sdrivemod
    gdsamod
    multihdreadonly
  elif [[ "$transport" == "sc" ]]; then
    gdrivemod
    sdrivemod
    gdsamod
    gcryptmod
    scryptmod
    gdsacryptmod
    multihdreadonly
  fi

cat /pg/logs/.drivelog
logcheck=$(cat /pg/logs/.drivelog | grep "Failed")

if [[ "$logcheck" == "" ]]; then
  if [[ "$transport" == "gd" || "$transport" == "gc" || "$transport" == "sd" || "$transport" == "sc" ]]; then executetransport; fi
else
  if [[ "$transport" == "sd" || "$transport" == "sc" ]]; then
  emessage="
  NOTE1: User forgot to share out GDSA E-Mail to Team Drive
  NOTE2: Conducted a blitz key restore and keys are no longer valid
  "; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 RClone Mount Checks - Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CANNOT DEPLOY!

POSSIBLE REASONS:
1. GSuite Account is no longer valid or suspended
2. Client ID and/or Secret are invalid and/or no longer exist
$emessage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
clonestart
fi
}

########################################################################################
gdrivemod ()
{
  initial=$(gclone lsd --config /pg/rclone/blitz.conf gd: | grep -oP plexguide | head -n1)

  if [[ "$initial" != "plexguide" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf gd:/plexguide
    initial=$(gclone lsd --config /pg/rclone/blitz.conf gd: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "GDRIVE :  Passed" >> /pg/logs/.drivelog; else echo "GDRIVE :  Failed" >> /pg/logs/.drivelog; fi
}
sdrivemod ()
{
  initial=$(gclone lsd --config /pg/rclone/blitz.conf sd: | grep -oP plexguide | head -n1)

  if [[ "tinitial" != "plexguide" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf gd:/plexguide
    initial=$(gclone lsd --config /pg/rclone/blitz.conf sd: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "SDRIVE :  Passed" >> /pg/logs/.drivelog; else echo "SDRIVE :  Failed" >> /pg/logs/.drivelog; fi
}
gcryptmod ()
{
  c1initial=$(gclone lsd --config /pg/rclone/blitz.conf gd: | grep -oP encrypt | head -n1)
  c2initial=$(gclone lsd --config /pg/rclone/blitz.conf gc: | grep -oP plexguide | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf gd:/encrypt
    c1initial=$(gclone lsd --config /pg/rclone/blitz.conf gd: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "plexguide" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf gc:/plexguide
    c2initial=$(gclone lsd --config /pg/rclone/blitz.conf gc: | grep -oP plexguide | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "GCRYPT1:  Passed" >> /pg/logs/.drivelog; else echo "GCRYPT1:  Failed" >> /pg/logs/.drivelog; fi
  if [[ "$c2initial" == "plexguide" ]]; then echo "GCRYPT2:  Passed" >> /pg/logs/.drivelog; else echo "GCRYPT2:  Failed" >> /pg/logs/.drivelog; fi
}
scryptmod ()
{
  c1initial=$(gclone lsd --config /pg/rclone/blitz.conf sd: | grep -oP encrypt | head -n1)
  c2initial=$(gclone lsd --config /pg/rclone/blitz.conf sc: | grep -oP plexguide | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf sd:/encrypt
    c1initial=$(gclone lsd --config /pg/rclone/blitz.conf sd: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "plexguide" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf sc:/plexguide
    c2initial=$(gclone lsd --config /pg/rclone/blitz.conf sc: | grep -oP plexguide | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "SCRYPT1:  Passed" >> /pg/logs/.drivelog; else echo "SCRYPT1:  Failed" >> /pg/logs/.drivelog; fi
  if [[ "$c2initial" == "plexguide" ]]; then echo "SCRYPT2:  Passed" >> /pg/logs/.drivelog; else echo "SCRYPT2:  Failed" >> /pg/logs/.drivelog; fi
}
gdsamod ()
{
  initial=$(gclone lsd --config /pg/rclone/blitz.conf GDSA01: | grep -oP plexguide | head -n1)

  if [[ "$initial" != "plexguide" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf GDSA01:/plexguide
    initial=$(gclone lsd --config /pg/rclone/blitz.conf GDSA01: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "GDSA01 :  Passed" >> /pg/logs/.drivelog; else echo "GDSA01 :  Failed" >> /pg/logs/.drivelog; fi
}
gdsacryptmod ()
{
  initial=$(gclone lsd --config /pg/rclone/blitz.conf GDSA01C: | grep -oP encrypt | head -n1)

  if [[ "$initial" != "plexguide" ]]; then
    gclone mkdir --config /pg/rclone/blitz.conf GDSA01C:/plexguide
    initial=$(gclone lsd --config /pg/rclone/blitz.conf GDSA01C: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "GDSA01C:  Passed" >> /pg/logs/.drivelog; else echo "GDSA01C:  Failed" >> /pg/logs/.drivelog; fi
}
################################################################################
deployblitzstartcheck () {

pgclonevars
if [[ "$displaykey" == "0" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  There are [0] keys generated for PG Blitz! Create those first!

NOTE: Without any keys, PG Blitz cannot upload any data without the use
of service accounts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi
}
