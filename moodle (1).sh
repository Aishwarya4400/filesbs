#! /bin/bash
sudo apt-get update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install php7.4-fpm -y
sudo apt-get install mysql-client -y
sudo apt install graphviz aspell ghostscript clamav -y
sudo apt-get install php7.4-mysql php7.4-ldap php7.4-common php7.4-gd php7.4-intl php7.4-xmlrpc php7.4-soap -y
sudo apt-get install php7.4-cli php7.4-pspell php7.4-zip php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath -y
sudo apt-get install php7.4-pear -y
sudo echo 'server {
    listen 80;
    listen [::]:80;
    root /var/www/html/moodle/;
    index index.php index.html index.htm;
    server_name sridhar.tk blog.sridhar.tk;

    location / {
        try_files $uri $uri/ =404;
    }

    location /dataroot/ {
        internal;
        alias /var/moodledata/;
    }

    location ~ [^/]\.php(/|$) {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' > /etc/nginx/sites-available/sridhar
sudo ln -s /etc/nginx/sites-available/sridhar /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
wget https://download.moodle.org/download.php/direct/stable36/moodle-3.6.2.tgz
tar -xvf moodle-3.6.2.tgz
cd moodle
sudo mkdir /var/www/html/moodle
sudo mv * /var/www/html/moodle
sudo chown -R www-data: /var/www/html/moodle
sudo mkdir /var/moodledata
sudo chown -R www-data /var/moodledata
sudo chmod -R 777 /var/moodledata
sudo chmod -R 0755 /var/www/html/moodle
sudo systemctl restart nginx

sudo mysql -h ${aws_db_instance.mysql.endpoint} -u root -p ${var.db-password} -e "create database moodle;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'password';
grant all on moodle.* to moodleuser@localhost identified by 'password' with grant option;
flush privileges;
exit;"
