#!/bin/bash -x
set +e

#log output from this user_data script
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

#create environment variables used in cron tasks.
echo "#Creating environment variables used in cron tasks"
echo "S3_BACKUP_BUCKET=s3://`${ghost_resources_bucket}`" >> /etc/environment

echo "#Installing AWS CLI 2.0"
apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/home/awscliv2.zip"
cd /home
unzip ./awscliv2.zip
sudo ./aws/install

echo "#Installing Docker and Docker-Compose"
snap install docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "#Clone Ghost project from GitHub"
cd /home
git clone https://github.com/sionsmith/docker-compose-ghost-quickstart.git
#update the production config with the correct name to sort out the links in the menu
sed -i 's/yourdomain/${domain}/' docker-compose-ghost-quickstart/ghost/config.production.json
sed -i 's/CHANGE_USERNAME/${ses_username}/' docker-compose-ghost-quickstart/ghost/config.production.json
sed -i 's/CHANGE_PASSWORD/${ses_password}/' docker-compose-ghost-quickstart/ghost/config.production.json
sed -i 's/CHANGE_FROM_EMAIL/${ses_email}/' docker-compose-ghost-quickstart/ghost/config.production.json

cd docker-compose-ghost-quickstart
docker-compose up --build -d

echo "#Copying any themes from S3 to local content mount"
#copy any themes from s3 into the volume mapping
sleep 15
/usr/local/bin/aws s3 sync s3://ghost-resources-eu-west-1-259100015265/themes/ ./ghost/content/themes/ --exact-timestamps --delete
#restart the ghost container
docker restart ghost

echo "#Create cron task for backup job every night at 1 am"
crontab<<EOF
0 1 * * * /home/docker-compose-ghost-quickstart/scripts/db-backup.sh
EOF