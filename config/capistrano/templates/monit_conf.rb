/var/www/open_cook_web/data/www/open-cook.ru/shared/pids/unicorn.pid

check process <%= application %>_unicorn with pidfile <%= unicorn_pid %>
  start program = "/etc/init.d/unicorn_<%= application %> start"
  stop program  = "/etc/init.d/unicorn_<%= application %> stop"

<% unicorn_workers.times do |n| %>
  <% pid = unicorn_pid.sub(".pid", ".#{n}.pid") %>
  check process <%= application %>_unicorn_worker_<%= n %> with pidfile <%= pid %>
    start program = "/bin/true"
    stop  program = "/usr/bin/test -s <%= pid %> && /bin/kill -QUIT `cat <%= pid %>`"
    
    if mem > 200.0 MB for 1 cycles then restart
    if cpu > 25% for 3 cycles then restart
    if 5 restarts within 5 cycles then timeout
    if changed pid 2 times within 60 cycles then alert
<% end %>