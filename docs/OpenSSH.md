## OpenSSH Server

### Install OpenSSH server

Make sure the system is up-to-date before installing OpenSSH server

```
sudo apt update && sudo apt upgrade -y
```

Install OpenSSH server

```
sudo apt install openssh-server
```

Start OpenSSH server and check its status

```
sudo systemctl enable ssh
sudo systemctl status ssh
```

### Configure OpenSSH server

The server config file is `/etc/ssh/sshd_config`. The client config file is `/etc/ssh/ssh_config` (client config file for current user `is ~/.ssh/config`).

Before changing the config file, make a backup (and make it read-only)

```
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
```

Once the OpenSSH is reconfigured, restart its service

```
sudo systemctl restart ssh
```

## OpenSSH Client

### Generate client user's public/private key pair

Generate key files using ed25519 algorithm, the key files are stored at `$HOME/.ssh/id_ed25519`(private) and `$HOME/.ssh/id_ed25519.pub` (public)

```
ssh-keygen -t ed25519
```

### Deploy the public key to OpenSSH server

The public key needs to be deployed to the SSH server: append the content of the public key to `$HOME/.ssh/authorized_keys` on the SSH server.

The easiest way for deploying a client's public key to the SSH server is to use `ssh-copy-id`

```
ssh-copy-id -i "$HOME/.ssh/id_ed25519" "user@ssh-server"
```

On Windows, if `ssh-copy-id` is not available, do this

```bat
type %userprofile%\.ssh\id_ed25519.pub | ssh user@ssh-server "cat >> ~/.ssh/authorized_keys"
```
or
```ps1
cat $env:userprofile/.ssh/id_ed25519.pub | ssh user@ssh-server 'cat >> ~/.ssh/authorized_keys'
```

Alternatively, copy the public key file to the ssh server then append its content to `authorized_keys`

```
scp /path/to/client/id_ed25519.pub user@ssh-server:/path/to/home/.ssh/id_ed25519.pub
ssh user@ssh-server "cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys"
```