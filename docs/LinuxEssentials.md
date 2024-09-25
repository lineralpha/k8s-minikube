[Linux Commands Cheat Sheet][1]

## Users and Groups

### Groups

There are two types of groups that a user can belong to:
- **Primary or login group:** That is assigned to the files that are created by the suer. It has the same name as the user.
- **Secondary or supplementary group:** that is used to grant certain privileges to a set of users. 

```sh
# /etc/groups contains the list of groups on the system,
# and the users belong to each of the groups (as secondary groups).
cat /etc/group

# find groups the current or a specific user belongs to.
# the first group in the output list is the primary group.
groups
groups <user>

# `man id` for reference
id
id <user>
id -g/u/G # options are exclusive, print only the id(s) respectively
id -n g/u/G # print names instead of ids

groupadd <new-user-group>   # create a new user group
groupadd -r <new-sys-group> # create a new system group (or using --system option)

# remove a group
groupdel <group-name>
```

### Users

```sh
# list all users on the system
cat /etc/passwd

# create a new user account
useradd <new-user>
useradd -r <new-sys-user> # create a system user
# john will use /bin/bash as login shell
useradd -s /bin/bash john
# specify primary group (-g) and secondary groups (-G)
useradd -g users -G docker john
# specify home directory (-m -d)
useradd -m -d opt/john john
# set user account password
passwd <user>

# remove a user from the system
userdel <user-name>
userdel -r <user-name> # force removing the user's home directory
# force removing the user even if the user is still logged in or has running processes.
userdel -f <user-name> # or use `killall -u <user-name>` first

# add users to a group
usermod -aG docker $USER # add current user to the docker group
# change the user's primary group
usermod -g <primary-group> <user-name>
# change the user's home directory
usermod -d <home-dir> <user-name>
# also move (-m) the content of the home directory to new location
usermod -d <home-dir> -m <user-name>
```

### File Permissions

```sh
# file permissions
# drwxr-xr-x. 4 root root   68 Jun 13 20:25 tuned
# -rw-r--r--. 1 root root 4017 Feb 24 2022 vimrc
#  ---------    |    |
#  |  |  |      |    group owner
#  |  |  |      user owner
#  |  |  permission for all other users
#  |  permission for group owner
#  permission for user owner

chown newowner:newgroup filename
chmod 755 filename
chmod ug+rwx,o=rx filename # same as chmod 775
chmod ugo+rwx filename # same as chmod 777
chmod u=r,g=wx,o=rx filename # same as chmod 435
```

## Packages

```sh
# `man apt` or `man apt-get` for more package management commands

# check if a particular package is installed
apt list --installed | grep package-name
# note, the package-name must be the exact name in the following command.
# so the above grep is preferred.
apt list openssh-client --installed
# check all upgradable packages
apt list --upgradable
dpkg --list # also list all installed packages
```

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

## Enlarge disk partition to use full Virtual disk on Linux VM

```sh
# install cloud-guest-utils
sudo apt install cloud-guest-utils
# expand /etc/sda1 partition into the free space:
sudo growpart /dev/sda 1
# run resize2fs
sudo resize2fs /dev/sda1
# check result
df -h
```

[1]: https://linuxopsys.com/linux-commands-cheat-sheet
