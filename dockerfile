
FROM ubuntu:20.04

ENV email=vdv2013@gmail.com
ENV domain=franko.cf
EXPOSE 80/tcp
EXPOSE 80/udp
EXPOSE 443/tcp
EXPOSE 443/udp
RUN apt-get update && apt-get upgrade -y && apt-get install curl -y
#Download Teleport's PGP public key
RUN curl https://deb.releases.teleport.dev/teleport-pubkey.asc -o /usr/share/keyrings/teleport-archive-keyring.asc


#Add the Teleport APT repository
RUN echo "deb [signed-by=/usr/share/keyrings/teleport-archive-keyring.asc] https://deb.releases.teleport.dev/ stable main" | tee /etc/apt/sources.list.d/teleport.list > /dev/null
RUN apt-get update && apt-get install teleport 


#Configure certificate
RUN openssl genrsa > /var/lib/teleport/privkey.pem && openssl req -x509 -new -key /var/lib/teleport/privkey.pem  \
    -subj "/CN=$domain" \
    -addext "subjectAltName=DNS:$domain,DNS:teleport.$domain" > /var/lib/teleport/fullchain.pem


#Configure teleport
RUN teleport configure -o file \
    --cluster-name=teleport.$domain \
    --public-addr=teleport.$domain:443 \
    --cert-file=/var/lib/teleport/fullchain.pem \
    --key-file=/var/lib/teleport/privkey.pem


#Run teleport and create admin user
RUN /usr/local/bin/teleport start  >> ~/teleport.log 2>&1 & sleep 15 && tctl users add teleport-admin --roles=editor,access --logins=root,ubuntu,ec2-use>

#Start teleport
CMD /usr/local/bin/teleport start

