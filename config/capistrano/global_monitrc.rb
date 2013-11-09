set daemon 30
set logfile   /var/log/monit.log
set idfile    /var/lib/monit/id
set statefile /var/lib/monit/state

set httpd port 2812 and
use address localhost
allow localhost

set eventqueue
    basedir /var/lib/monit/events # set the base directory where events will be stored
    slots 100                     # optionally limit the queue size

check process nginx with pidfile /var/run/nginx.pid
   group server
   start program = "/etc/init.d/nginx start"
   stop program  = "/etc/init.d/nginx stop"

   if cpu      > 80%       for 5 cycles then restart
   if totalmem > 2000.0 MB for 5 cycles then restart
   if children > 250       then restart
   if loadavg(5min) greater than 10 for 8 cycles then stop
   if 3 restarts within 5 cycles then timeout

check process apache with pidfile /var/run/apache2.pid
   group server
   start program = "/etc/init.d/apache2 start"
   stop program  = "/etc/init.d/apache2 stop"

   if cpu      > 80%       for 5 cycles then restart
   if totalmem > 2000.0 MB for 5 cycles then restart
   if children > 250       then restart
   if loadavg(5min) greater than 10 for 8 cycles then stop
   if 3 restarts within 5 cycles then timeout

check process mysql with pidfile /var/run/mysqld/mysqld.pid
  group server
  start program = "/etc/init.d/mysql start"
  stop program  = "/etc/init.d/mysql stop"
  if failed host localhost port 3306 protocol mysql then restart
  if 5 restarts within 5 cycles then timeout

include /etc/monit/conf.d/*

include /var/www/open_cook_web/data/www/open-cook.ru/shared/config/monit.conf
include /var/www/open_cook_web/data/www/zykin-ilya.ru/shared/config/monit.conf
include /var/www/open_cook_web/data/www/troya37.ru/shared/config/monit.conf
include /var/www/open_cook_web/data/www/iv-schools.ru/shared/config/monit.conf
include /var/www/open_cook_web/data/www/edu37.ru/shared/config/monit.conf

# if cpu > 60% for 2 cycles then alert

# if failed host www.tildeslash.com port 80 protocol http 
#   and request "/somefile.html"
#   then restart
# if failed port 443 type tcpssl protocol http
#   with timeout 15 seconds
#   then restart

######

# monit quit
# /etc/monit/monitrc
# service monit restart
# monit status