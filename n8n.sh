# IMPORTANT: remember to replace YOURDOMAIN within this file with your registered subdomain

sudo apt update
sudo install -y openssh-server dkms build-essential mc less htop zip unzip host wget curl net-tools rsync sqlite3

sudo apt-get install -y nginx apache2-utils libnginx-mod-http-headers-more-filter
sudo sed -i 's/# server_tokens off;/server_tokens off;\n\tmore_clear_headers Server;/g' /etc/nginx/nginx.conf
sudo sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/g' /etc/nginx/nginx.conf
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default
sudo rm -rf /var/www/html
sudo service nginx restart

curl -sL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs
sudo npm i n -g

sudo apt-get install -y python3-acme python3-certbot python3-certbot-nginx python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface

sudo wget -P /etc/nginx/sites-available https://raw.githubusercontent.com/andy-isd/n8n-selfhost-aws/refs/heads/main/etc/nginx/default
sudo wget -P /var/www/default https://raw.githubusercontent.com/andy-isd/n8n-selfhost-aws/refs/heads/main/var/www/docker-compose.yml

sudo chown root:www-data /var/www/default

sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo chmod +x get-docker.sh
sudo ./get-docker.sh

sudo docker volume create n8n_data
cd /var/www/default
sudo docker compose up -d

# IMPORTANT: replace YOURDOMAIN with your subdomain here
sudo sed -i 's/DOMAIN/YOURDOMAIN/g' /etc/nginx/sites-available/default
sudo ln -fns /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo service nginx reload

# IMPORTANT: replace YOURDOMAIN with your subdomain here
echo "Obtaining SSL certificate"
sudo certbot --register-unsafely-without-email --agree-tos -d YOURDOMAIN
