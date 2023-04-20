#!/bin/bash

# check_debian_updates installation
sudo mkdir /etc/cron.nagios
sudo cp specs/debian_updates /etc/cron.nagios/
sudo chmod +x /etc/cron.nagios/debian_updates
sudo echo "" >> /etc/crontab
sudo echo "0 */2 * * *     root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.nagios )" >> /etc/crontab
sudo echo "" >> /etc/crontab