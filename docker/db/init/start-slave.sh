#!/bin/sh

# masterをロック
mysql -u root -h master -e "RESET MASTER;"
mysql -u root -h master -e "FLUSH TABLES WITH READ LOCK;"

# master情報をdump
mysqldump -u root -h master --all-databases --master-data --single-transaction --flush-logs --events > /tmp/master_dump.sql

# slaveにimport
mysql -u root -e "STOP SLAVE;";
mysql -u root < /tmp/master_dump.sql

# bin-logのファイル名とポジションを取得
log_file=`mysql -u root -h master -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'`
pos=`mysql -u root -h master -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}'`

# slave開始
mysql -u root -e "RESET SLAVE;";
mysql -u root -e "CHANGE MASTER TO MASTER_HOST='master', MASTER_USER='repl', MASTER_PASSWORD='Zaq1Zaq1', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos};"
mysql -u root -e "START SLAVE;"

# masterをunlockする
mysql -u root -h master -e "UNLOCK TABLES;"
