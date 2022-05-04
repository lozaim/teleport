
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
RUN apt-get update && apt-get install teleport certbot -y 

#Configure teleport
RUN teleport configure --acme --acme-email=$email --cluster-name=teleport.$domain | tee /etc/teleport.yaml > /dev/null

#Copy run-script
COPY ./conf.sh /etc/conf.sh
CMD /usr/bin/sh /etc/conf.sh
