# Screw all this, let's just fucking make these on the fly
# Same as screen, I cannot fucking figure out how to launch a process
# that'll drop me back into bash if I ^C it.

echo "#! /usr/bin/env bash
sudo service memcached stop
sudo service mysql stop
sudo apache2ctl stop
sudo /opt/lampp/lampp restart
sudo /opt/lampp/memcached/bin/memcached -m 100 -d -u nobody -l 127.0.0.1
sudo su - -c 'cd /opt/lampp'
/usr/bin/env bash
" > /tmp/lampp_start

echo "#! /usr/bin/env bash
tail -n 0 -f /media/mobilityserver/log/*.log
/usr/bin/env bash
" > /tmp/log_ms

echo "#! /usr/bin/env bash
tail -n 0 -f /media/csmobility/log/*.log
/usr/bin/env bash
" > /tmp/log_msadmin

echo "#! /usr/bin/env bash
tail -n 0 -f /opt/lampp/logs/error_log
/usr/bin/env bash
" > /tmp/log_error

echo "#! /usr/bin/env bash
cd /media/mobilityserver/
/usr/bin/env bash
" > /tmp/cd_ms

echo "#! /usr/bin/env bash
cd /media/csmobility/
/usr/bin/env bash
" > /tmp/cd_msadmin

echo "#! /usr/bin/env bash
while [ ! -e /opt/lampp/var/mysql/mysql.sock ]; do 
    echo Sleeping until mysql wakes up; sleep 10; 
done;
/opt/lampp/bin/mysql -uroot mobilityserver
/usr/bin/env bash
" > /tmp/mysql_ms

echo "#! /usr/bin/env bash
while [ ! -e /opt/lampp/var/mysql/mysql.sock ]; do 
    echo Sleeping until mysql wakes up; sleep 10; 
done;
/opt/lampp/bin/mysql -uroot netowem
/usr/bin/env bash
" > /tmp/mysql_msadmin

chmod u+x /tmp/lampp_start   \
          /tmp/log_ms        \
          /tmp/log_msadmin   \
          /tmp/log_error     \
          /tmp/mysql_ms      \
          /tmp/mysql_msadmin \
          /tmp/cd_ms         \
          /tmp/cd_msadmin

if ! tmux has-session -t netomat 1>/dev/null 2>/dev/null; then
    # Create new session with a window that starts lampp
    tmux new-session -d -s netomat -n 'lampp' "/usr/bin/env bash /tmp/lampp_start"

    # Mobility Server and MSAdmin
    tmux new-window -d -n "mobilityserver" "/usr/bin/env bash /tmp/cd_ms"
    tmux new-window -d -n "msadmin"        "/usr/bin/env bash /tmp/cd_msadmin"

    # mysql
    tmux new-window -d -n "ms mysql"      "/usr/bin/env bash -c '/opt/lampp/bin/mysql -uroot mobilityserver; /bin/bash'"
    tmux new-window -d -n "msadmin mysql" "/usr/bin/env bash -c '/opt/lampp/bin/mysql -uroot netowem; /bin/bash'"    

    # Log windows
    tmux new-window -n "ms logs" "/usr/bin/env bash /tmp/log_ms"
    tmux new-window -n "msadmin logs" "/usr/bin/env bash /tmp/log_msadmin"
    tmux new-window -n "apache log" "/usr/bin/env bash /tmp/log_error"

    # This is where I get to type in my sudo password
    tmux select-window -t netomat:lampp

fi

# Clean up
rm /tmp/lampp_start   \
   /tmp/log_ms        \
   /tmp/log_msadmin   \
   /tmp/log_error     \
   /tmp/mysql_ms      \
   /tmp/mysql_msadmin \
   /tmp/cd_ms         \
   /tmp/cd_msadmin
   

# Attach
tmux attach -t netomat


