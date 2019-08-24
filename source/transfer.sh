#!/bin/bash
#
# Title:      Reference Title File - PGBlitz
# Author(s):  Admin9705 & https://github.com/PGBlitz/PGClone/graphs/contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
# NOTES
# Variables come from what's being called from deploytransfer.sh under functions
## BWLIMIT 9 and Lower Prevents Google 750GB Google Upload Ban
################################################################################
if pidof -o %PPID -x "$0"; then
   exit 1
fi

useragent="$(cat /pg/var/uagent)"
cleaner="$(cat /pg/var/cloneclean)"

var3=$(cat /pg/rclone/deploy.version)
if [[ "$var3" == "gd" ]]; then var4="gdrive"
elif [[ "$var3" == "gc" ]]; then var4="gdrive"
elif [[ "$var3" == "sd" ]]; then var4="sdrive"
elif [[ "$var3" == "sd" ]]; then var4="sdrive"

touch /pg/logs/transfer.log
touch /pg/logs/.transfer_list
touch /pg/logs/.temp_list

filecount=$(wc -l /pg/logs/.transfer_list | awk '{print $1}')
echo "$filecount" > /pg/var/filecount
if [[ "$filecount" -gt 8 ]]; then exit; fi

find /pg/transfer/ -type f > /pg/logs/.temp_list

while read p; do
  sed -i "/^$p\b/Id" /pg/logs/.temp_list
done </pg/logs/.transfer_list

head -n +1 /pg/logs/.temp_list >> /pg/logs/.transfer_list
uploadfile=$(head -n +1 /pg/logs/.temp_list)

if [[ "$uploadfile" == "" ]]; then exit; fi

chmod 775 -R {{hdpath}}/transfer/
chown 1000:1000 {{hdpath}}/transfer/
chown 1000:1000 "$uploadfile"
chmod 775 "$uploadfile"

if [[ "$var4" == "gdrive" ]]; then
  rclone moveto "$uploadfile" "{{type}}:/" \
  --config /pg/rclone/blitz.conf \
  --log-file=/pg/logs/transfer.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --tpslimit 6 \
  --checkers=20 \
  --bwlimit {{bandwidth.stdout}}M \
  --drive-chunk-size={{dcs}} \
  --user-agent="$useragent" \
  --exclude="**_HIDDEN~" --exclude="**partial~"  \
  --exclude=".fuse_hidden**" --exclude="**.grab/**"
else
  rclone moveto "$uploadfile" "${p}{{encryptbit}}:/" \
  --config /pg/rclone/blitz.conf \
  --log-file=/pg/logs/pgblitz.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --tpslimit 12 \
  --checkers=20 \
  --transfers=16 \
  --bwlimit {{bandwidth.stdout}}M \
  --user-agent="$useragent" \
  --drive-chunk-size={{dcs}} \
  --exclude="**_HIDDEN~" --exclude=".unionfs/**" \
  --exclude="**partial~" --exclude=".unionfs-fuse/**" \
  --exclude=".fuse_hidden**" --exclude="**.grab/**"  \
fi

sleep 5
grep -v "$uploadfile" "/pg/logs/.transfer_list" | sponge "/pg/logs/.transfer_list"

# Removes garbage | torrent folder excluded
#find "{{hdpath}}/downloads" -mindepth 2 -type d -cmin +$cleaner  $(printf "! -name %s " $(cat /pg/var/exclude)) -empty -exec rm -rf {} \;
#find "{{hdpath}}/downloads" -mindepth 2 -type f -cmin +$cleaner  $(printf "! -name %s " $(cat /pg/var/exclude)) -size +1M -exec rm -rf {} \;
exit 0
