#! /bin/bash
dbip="10.5.3.5"
FW_NIC2="10.5.2.4"
sudo apt-get update
sudo apt-get install -y apache2 wordpress
sudo ln -sf /usr/share/wordpress /var/www/html/wordpress
sudo gzip -d /usr/share/doc/wordpress/examples/setup-mysql.gz
while true; do
  resp=$(mysql -udemouser -ppaloalto@123 -h "$dbip" -e 'show databases')
  echo "$resp"
  if [[ "$resp" = *"Demo"* ]]
       then
            break
  fi
 sleep 5s
done
sudo bash /usr/share/doc/wordpress/examples/setup-mysql -n Demo -t "$dbip" "$dbip"
sudo sed -i "s/define('DB_USER'.*/define('DB_USER', 'demouser');/g" /etc/wordpress/config-"$dbip".php
sudo sed -i "s/define('DB_PASSWORD'.*/define('DB_PASSWORD', 'paloalto@123');/g" /etc/wordpress/config-"$dbip".php
sudo wget -O /usr/lib/cgi-bin/guess-sql-root-password.cgi https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/guess-sql-root-password.cgi
sudo chmod +x /usr/lib/cgi-bin/guess-sql-root-password.cgi
sudo sed -i "s/DB-IP-ADDRESS/$dbip/g" /usr/lib/cgi-bin/guess-sql-root-password.cgi
sudo wget -O /usr/lib/cgi-bin/ssh-to-db.cgi https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/ssh-to-db.cgi
sudo chmod +x /usr/lib/cgi-bin/ssh-to-db.cgi
sudo sed -i "s/DB-IP-ADDRESS/$dbip/g" /usr/lib/cgi-bin/ssh-to-db.cgi
sudo wget -O /var/www/html/showheaders.php https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/showheaders.php
sudo wget -O /var/www/html/sql-attack.html https://raw.githubusercontent.com/jasonmeurer/azure-appgw-stdv2/master/sql-attack.html
sudo ln -sf /etc/apache2/conf-available/serve-cgi-bin.conf /etc/apache2/conf-enabled/serve-cgi-bin.conf
sudo ln -sf /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load
sudo ln -s /etc/wordpress/config-"$dbip".php /etc/wordpress/config-default.php
sudo systemctl restart apache2

