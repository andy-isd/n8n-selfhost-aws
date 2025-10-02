sudo apt update
sudo install -y openssh-server dkms build-essential mc less htop zip unzip host wget curl net-tools rsync sqlite3

sudo apt-get install -y nginx apache2-utils libnginx-mod-http-headers-more-filter
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default
sudo service nginx restart

sudo wget -P /etc/nginx/sites-available https://raw.githubusercontent.com/andy-isd/n8n-selfhost-aws/refs/heads/main/etc/nginx/default
sudo wget -P /var/www/default https://raw.githubusercontent.com/andy-isd/n8n-selfhost-aws/refs/heads/main/var/www/docker-compose.yml

sudo chown root:www-data /var/www/default

sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo chmod +x get-docker.sh
sudo ./get-docker.sh

# IMPORTANT: replace YOURDOMAIN with your subdomain here
sudo docker volume create n8n_data
cd /var/www/default
sudo sed -i 's/http/https/g' /var/www/default/docker-compose.yml
sudo sed -i 's/127.0.0.1:5678/YOURDOMAIN/g' /var/www/default/docker-compose.yml
sudo docker compose up -d

# IMPORTANT: replace YOURDOMAIN with your subdomain here
sudo sed -i 's/DOMAIN/YOURDOMAIN/g' /etc/nginx/sites-available/default
sudo ln -fns /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo service nginx reload

# IMPORTANT: replace YOURDOMAIN with your subdomain here
sudo certbot --register-unsafely-without-email --agree-tos -d YOURDOMAIN
