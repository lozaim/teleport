# teleport

docker build -f dockerfile .

From STEP 13/14 docker print to shell like

User "teleport-admin" has been created but requires a password. Share this URL with the user to complete user setup, link is valid for 1h:
https://teleport.franko.gq:443/web/invite/9edec4fd8a95c5c7c0c0f2e3a8159f5d

use this link to create your admin user after docker run

docker run -p 443:443 $image_id

