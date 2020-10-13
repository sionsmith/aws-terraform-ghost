#!/bin/bash -x
set +e

#log output from this user_data script
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

#install docker and docker-compose
snap install docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#clone Ghost project
cd /home
git clone https://github.com/sionsmith/docker-compose-ghost-quickstart.git
#update the production config with the correct name to sort out the links in the menu
sed -i 's/yourdomain/${domain}/' docker-compose-ghost-quickstart/ghost/config.production.json
cd docker-compose-ghost-quickstart
docker-compose up --build -d