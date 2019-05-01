sudo apt-get update
sudo apt-get -y install debconf-utils 
sudo DEBIAN_FRONTEND=noninteractive | apt-get install -y mysql-server 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "DELETE FROM mysql.user WHERE User=''" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_localhost';"
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "FLUSH PRIVILEGES;" 
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql && sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "CREATE DATABASE Demo;" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "CREATE USER 'demouser'@'%' IDENTIFIED BY 'paloalto@123';" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "GRANT ALL PRIVILEGES ON Demo.* TO 'demouser'@'%';" 
sudo mysql --defaults-file=/etc/mysql/debian.cnf -e "FLUSH PRIVILEGES;"
