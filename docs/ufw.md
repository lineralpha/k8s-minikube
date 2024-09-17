## UFW commands

### UFW status

Check if UFW is enabled
```sh
sudo ufw status
```

To enable/disable UFW on the system
```sh
sudo ufw enable
sudo ufw disable
```
### UFW rule management

```sh
# block incoming connections from an ip-address or a subnet
sudo ufw deny from 203.0.113.100
sudo ufw deny from 203.0.113.0/24  # /24 = 24 bits out of the 32 bits is used by the subnet
# block incoming connections to a network interface
sudo ufw deny in on eth0 from 203.0.113.100

# allow incoming connections from an ip-address or a subnet
sudo ufw allow from 203.0.113.100
sudo ufw allow from 203.0.113.0/24
sudo ufw allow in on eth0 from 203.0.113.100

# delete an allow rule
sudo ufw delete allow from 203.0.113.100
# delete a rule using a rule number
sudo ufw delete 1 # rule numbers can be obtained by command `sudo ufw status numbered`
```

### UFW application profiles

```sh
sudo ufw app list         # list all application profiles
sudo ufw allow "OpenSSH"  # enable OpenSSH
sudo ufw allow 22         # enable port 22 (which is the default ssh port)
sudo ufw allow "Nginx HTTPS"
sudo ufw delete allow "Nginx Full"
sudo ufw allow from 203.0.113.0/24 proto tcp to any port 22

sudo ufw allow http       # same as `sudo ufw allow 80`
sudo ufw allow https      # same as `sudo ufw allow 443`
sudo ufw allow proto tcp from any to any port 80,443

# enable connection to MySQL
sudo ufw allow from 203.0.113.0/24 to any port 3306 # MySQL port is 3306

# block outgoing SMTP mail
sudo ufw deny out 25    # smtp port 25

```

### The /etc/passwd file

This file stores essential info about the users on the system.

```
-rw-r--r-- 1 root root 2932 Sep 12 02:16 /etc/passwd
```

Each entry in the file represents a user on the system. The user entry contains 7 fields (delimited by :)

```sh
grep dfli /etc/passwd
dfli:x:1000:1000:Daofa Li,,,:/home/dfli:/bin/bash
```

### Users on Linux system
add new user
add user to a group

### file permissions
```sh
# check if a particular package are installed
apt list --installed | grep package-name
# note, the package-name must be the exact name in the following command. so the above grep is preferred.
apt list openssh-client --installed
# check all upgradable packages
apt list --upgradable
```

### Packages


### Linux essentials
```sh
# add user (you must be the root user)
adduser sammy  # sammy is the new user
usermod -aG sudo sammy # add sammy to sudo group
chown newowner:newgroup filename
chmod 755 filename
chmod ug+rwx,o=rx filename # same as chmod 775
chmod ugo+rwx filename # same as chmod 777
chmod u=r,g=wx,o=rx filename # same as chmod 435


# file permissions
# drwxr-xr-x. 4 root root   68 Jun 13 20:25 tuned
# -rw-r--r--. 1 root root 4017 Feb 24 2022 vimrc
#  ---------    |    |
#  |  |  |      |    group owner
#  |  |  |      user owner
#  |  |  permission for all other users
#  |  permission for group owner
#  permission for user owner
```
