use mysql;
update mysql.user set authentication_string=password('root') where user='root';
CREATE DATABASE beiyun CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE beiyun_volume CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'beiyun'@'%' IDENTIFIED BY '111111' WITH GRANT OPTION;
flush privileges;
