# check_debianoffspring_updates.sh
> Nagios NCPA plugin to monitor Debian and Ubuntu updates


1. Execute the `install.sh` if you want the plugin installed automatically on the Debian machine you want to monitor updates. It will automatically create the cron task for the `apt update` command
```bash
sudo bash install.sh
```
2. Copy the check_debian_updates in the plugin folder of the NCPA agent, chown it to nagios:nagios user and give the execution permission on the script. It can be done in one time with this command
```bash
sudo cp check_debianoffspring_updates.sh /usr/local/ncpa/plugins/ ; sudo chown nagios:nagios /usr/local/ncpa/plugins/check_debianoffspring_updates.sh ; sudo chmod +x /usr/local/ncpa/plugins/check_debianoffspring_updates.sh
```
3. Configure your Nagios server to create a command and a service associated to the server or server groups you want to monitor. Here is an example:
```shell

# Command definition
# Debian updates
define command {
    command_name check_ncpa_debianoffspring_updates
    command_line $USER1$/check_ncpa.py -H $HOSTADDRESS$ -t 'token' -M 'plugins/check_debianoffspring_updates.sh'
}

# Service definition for the Linux group machines (use host_name instead of hostgroup_name if you have only one host to monitor)
# Debian updates
define service {
    use                     generic-service
    hostgroup_name          Linux
    service_description     Debian updates
    check_command           check_ncpa_debianoffspring_updates
    contacts                admin
    max_check_attempts      3
    check_interval          5
    retry_interval          1
}
```
![alt text](https://github.com/John4887/check_debian_updates/blob/main/check_debian_updates_OK.png)
![alt text](https://github.com/John4887/check_debian_updates/blob/main/check_debian_updates_WARNING.png)
![alt text](https://github.com/John4887/check_debian_updates/blob/main/check_debian_updates_CRITICAL.png)
![alt text](https://github.com/John4887/check_debianoffspring_updates/blob/main/check_debianoffspring_updates_OK-phased-updates_Ubuntu.png)
![alt text](https://github.com/John4887/check_debianoffspring_updates/blob/main/check_debianoffspring_updates_CRITICAL_Ubuntu.png)
![alt text](https://github.com/John4887/check_debianoffspring_updates/blob/main/check_debianoffspring_updates_CRITICAL_Ubuntu_02.png)

> The plugin will give you OK if there are no updates (or only phased updates in Ubuntu case also), WARNING if there are updates but none of them are security, stable or kernel updates and CRITICAL if at least one update concerns security, stable updates or kernel.
