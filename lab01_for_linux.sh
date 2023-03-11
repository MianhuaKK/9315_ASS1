#!/bin/bash

echo "默认在当前文件目录下安装postgresql"
echo "更多资料：请添加微信:marey_marey111"

db_version='postgresql-15.1'

# 下载文件
FILE=$db_version.tar.bz2
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "正在下载最新的postgresql数据库源代码文件"
    wget https://ftp.postgresql.org/pub/source/v15.1/$db_version.tar.bz2
    echo "下载完成"
fi

# 下载env文件

FILE=env
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    rm -f "$FILE"
fi

echo "正在下载env文件"
wget https://cgi.cse.unsw.edu.au/~cs9315/23T1/postgresql/env
echo "下载完成" 


cur_path=$(pwd)

echo "当前的文件目录是:$cur_path"

read -p "Do you wish to install the path: $cur_path?[Yy/Nn] " yn
    case $yn in
        [Yy]* ) ;;
        [Nn]* ) read -p "Please input your path " cur_path;;
        * ) echo "Please answer yes or no.";;
    esac

# echo "s/localstorage/$cur_path/g" 

sed -i "s+/localstorage/\$USER+$cur_path+g" env


sudo tar xfj $db_version.tar.bz2
cd $db_version

rm -rf $cur_path/pgsql

./configure --prefix=$cur_path/pgsql
sudo make && make install
cd ..
pwd
source ./env
which initdb
# $cur_path/pgsql/bin/initdb
initdb
ls $PGDATA

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = ''/g" $PGDATA/postgresql.conf
sed -i "s/max_connections = 100/max_connections = 8/g" $PGDATA/postgresql.conf
sed -i "s/#max_wal_senders = 10/max_wal_senders = 4/g" $PGDATA/postgresql.conf
sed -i "s+#unix_socket_directories = '/tmp'+unix_socket_directories = '$cur_path/pgsql/data'+g" $PGDATA/postgresql.conf

which pg_ctl
pg_ctl start -l $PGDATA/log
psql -l

cd $cur_path

rm -rf testing

mkdir testing

cd testing

wget https://cgi.cse.unsw.edu.au/~cs9315/23T1/assignment/1/testing/testing.tar

tar -xf testing.tar

wget https://cgi.cse.unsw.edu.au/~cs9315/23T1/assignment/1/testing/run_test.py

wget https://cgi.cse.unsw.edu.au/~cs9315/23T1/assignment/1/testing/Makefile