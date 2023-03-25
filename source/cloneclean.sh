### Falls under PG Prune for Execution to Save Time & Sanity

# Outside Variables
dlpath=$(cat /opt/var/server.hd.path)
cleaner="$(cat /opt/var/cloneclean)"

# Starting Actions
touch /opt/logs/pgblitz.log
mkdir -p "$dlpath/move"

# Repull excluded folder 
 wget -qN https://raw.githubusercontent.com/PGBlitz/PGClone/v8.6/functions/exclude -P /opt/var/

# Permissions
chown -R 1000:1000 "$dlpath/move"
chmod -R 775 "$dlpath/move"

# Remove empty directories
find "$dlpath/move/" -type d -mmin +2 -empty -exec rm -rf {} \;

# Removes garbage
find "$dlpath/downloads" -mindepth 2 -type d -cmin +$cleaner $(printf "! -name %s " $(cat /opt/var/exclude)) -empty -exec rm -rf {} \;
find "$dlpath/downloads" -mindepth 2 -type f -cmin +$cleaner $(printf "! -name %s " $(cat /opt/var/exclude)) -size +1M -exec rm -rf {} \;
