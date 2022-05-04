#!/bin/sh 

domain=franko.cf

#Configure certbot
certbot certonly --standalone \
                      -d teleport.$domain \
                      -n \
                      --agree-tos \
                      --email=$email 
# Add renewal certbot
echo '5 4 1 */2 * certbot certonly --standalone -d teleport.$domain -n --force-renewal' >> /etc/crontab

#Add Certificate to config
sed 's/^  https_keypairs:.*/  https_keypairs:/g' teleport.yaml > teleport.yaml
sed '/^  https_keypairs:.*/a\ \  cert_file: /etc/letsencrypt/live/teleport.$domain/fullchain.pem' teleport.yaml > teleport.yaml
sed '/^  https_keypairs:.*/a\ \ - key_file: /etc/letsencrypt/live/teleport.$domain/privkey.pem' teleport.yaml > teleport.yaml



#Start teleport
/usr/local/bin/teleport start

#Create admin user
tctl users add teleport-admin --roles=editor,access --logins=root,ubuntu,ec2-user >> teleport-admin && cat teleport-admin
