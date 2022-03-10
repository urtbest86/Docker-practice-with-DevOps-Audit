#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
set -e

VERSION="1.10.1"

if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    # assume Zsh
    shell_profile="zshrc"
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
    # assume Bash
    shell_profile="bashrc"
fi

echo "System Info :\n";

Kernel=$(uname -s)
case "$Kernel" in
    Linux)  Kernel="linux"              ;;
    Darwin) Kernel="mac"                ;;
    FreeBSD)    Kernel="freebsd"            ;;
* ) echo "Your Operating System -> ITS NOT SUPPORTED"   ;;
esac

echo "Operating System Kernel : $Kernel"

echo -----------------------------------------------------------------
echo -                    Mongo - Ubuntu                       -
echo -----------------------------------------------------------------

# echo "Unistalling Previous Repo"
# apt-get purge -y mongodb-org*
# rm -r /var/log/mongodb
# rm -r /var/lib/mongodb

echo "Installing repo"
 
echo "Installing binaries"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

apt-get update
apt-get install -y mongodb-org
apt-get update

cat > /etc/systemd/system/mongodb.service <<'EOF'
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf
[Install]
WantedBy=multi-user.target
EOF

echo "File Edited"

#sudo systemctl start mongodb
#sudo systemctl status mongodb
systemctl enable mongod.service

service mongod stop
 
 
echo "Setting up default settings"
rm -rf /var/lib/mongodb/*
cat > /etc/mongod.conf <<'EOF'
storage:
  dbPath: /var/lib/mongodb
  directoryPerDB: true
  journal:
    enabled: true
  engine: "wiredTiger"
 
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
 
net:
  port: 27017
  bindIp: 0.0.0.0
  maxIncomingConnections: 100
 
replication:
  oplogSizeMB: 128
  replSetName: "rs1"
 
security:
  authorization: enabled
 
EOF
 
service mongod start
sleep 5
 
mongo admin <<'EOF'
use admin
rs.initiate()
exit
EOF
 
sleep 5
 
echo "Adding admin user"
mongo admin <<'EOF'
use admin
rs.initiate()
var user = {
  "user" : "admin",
  "pwd" : "123qwe!@#",
  roles : [
      {
          "role" : "userAdminAnyDatabase",
          "db" : "admin"
      }
  ]
}
db.createUser(user);
exit
EOF

echo "Adding lam user"
mongo admin <<'EOF'
use lam
rs.initiate()
var user = {
  "user" : "user1",
  "pwd" : "123qwe!@#",
  roles : [
      {
          "role" : "dbOwner",
          "db" : "lam"
      }
  ]
}
db.createUser(user);
exit
EOF
 
echo "Complete"
