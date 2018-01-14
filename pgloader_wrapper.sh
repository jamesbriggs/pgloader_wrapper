#!/bin/bash

# Program: pgloader_wrapper.sh
# Purpose: pgloader wrapper script/system to allow rapid database migration iterations from MySQL to Postgresql
# Author: James Briggs, USA
# Date: 2018 01 12
# Env: Postgresql 9.2+ on CentOS 7.x
# Note: to prevent data loss, use this migration script in dev and qa, not prod!

###
### start of user-configurable settings
###

# either leave empty if you're logged in as root, or enter 'sudo'
sudo=""

# the postgres linux user account is the default pg superuser
psudo="sudo -u postgres"

# where to find the pgloader binary
pgloader=/usr/local/bin/pgloader

# how many connections your dev or qa pg server needs, default is usally 100
pg_connections=100

# your database/schema name
db=mydb

# your application user/role password (users and roles are the same thing in pg)
pw=mypw

# httpd or nginx service name
httpd=httpd

# optional cache to flush
flush_cache="redis-cli FLUSHALL"

# space-separated (actually $IFS) list of hostnames to immediately abort on
prod_blacklist=""

# your customized pgloader .load file
loadfile=pgloader.load

###
### end of user-configurable settings
###

function cleanup {
   $psudo psql -c "drop database if exists $db;"
   echo "`date` $0 error: a step failed, so dropping $db and exiting"
   exit 1
}
trap cleanup INT TERM EXIT

$sudo echo "`date` $0 start" >>$0.log

host=`hostname`
for i in $prod_blacklist; do
   if [[ "x$i" == "x$host" ]]; then
      msg = "`date` $0 error: $host is blacklisted by $0. Exiting immediately."
      echo $msg >&2
      $sudo echo $msg >>$0.log
      $sudo echo "`date` $0 end" >>$0.log
      exit 1
   fi
done

# stop database clients here before loading database
$sudo service $httpd stop
$sudo $flush_cache

# See https://dba.stackexchange.com/questions/11893/force-drop-db-while-others-may-be-connected

# disallow non-superusers to our database
$psudo psql -c "ALTER DATABASE $db CONNECTION LIMIT 1;"

# kill connections to our database in 9.2+
$psudo psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$db';"

# in pg, a database is the outer container for the schema, grants and other objects

$psudo psql -c "drop database if exists $db;"
$psudo psql -c "create database $db;"

# pgloader will create the schema inside database $db
$psudo $pgloader $PWD/$loadfile

$psudo DBNAME="$db" USERPW="$pw" psql -f $PWD/grants.sql -d $db

# allow non-superusers to our database
$psudo psql -c "ALTER DATABASE $db CONNECTION LIMIT $pg_connections;"

# start database clients here after loading database
$sudo service $httpd start
$sudo $flush_cache

$sudo echo "`date` $0 end" >>$0.log

trap - INT TERM EXIT
