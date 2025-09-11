# installing basic apps
sudo apt update
sudo install -y openssh-server dkms build-essential mc less htop zip unzip host wget curl net-tools rsync sqlite3

# nginx
sudo apt-get install -y nginx apache2-utils libnginx-mod-http-headers-more-filter
sudo sed -i 's/# server_tokens off;/server_tokens off;\n\tmore_clear_headers Server;/g' /etc/nginx/nginx.conf
sudo sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/g' /etc/nginx/nginx.conf
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default
sudo rm -rf /var/www/html
sudo service nginx restart

echo "Nodejs & NPM setup"
curl -sL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs
sudo npm i n -g

echo "Installing letsencrypt certbot"
sudo apt-get install -y python3-acme python3-certbot python3-certbot-nginx python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface

# downloading files
echo "Downloading files..."
sudo wget -P /etc/nginx/sites-available https://raw.githubusercontent.com/andy-isd/n8n-selfhost-aws/refs/heads/main/etc/nginx/default
sudo wget -P /var/www/default https://raw.githubusercontent.com/andy-isd/n8n-selfhost-aws/refs/heads/main/var/www/docker-compose.yml

sudo chown root:www-data /var/www/default

echo "Installing docker"
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo chmod +x get-docker.sh
sudo ./get-docker.sh

echo "Running n8n from docker container"
sudo docker volume create n8n_data
cd /var/www/default
sudo docker compose up -d

echo "Setting up nginx host"
sudo sed -i 's/DOMAIN/YOURDOMAIN/g' /etc/nginx/sites-available/default
sudo ln -fns /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo service nginx reload

echo "Obtaining SSL certificate"
sudo certbot --register-unsafely-without-email --agree-tos -d YOURDOMAIN
