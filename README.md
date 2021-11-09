# Mailserver
postfix-dovecot-roundqube-postfixadmin setup, backed by MariaDB, on Ubuntu 20.04

Mostly based on [Workaround.org's ISPMail tutorial for Debian Buster](https://workaround.org/ispmail/buster/)

## TODO
See project tab

## Installation
run the following as root
```sh
curl -sSL https://github.com/gardient/mailserver/raw/main/install | bash
```

or you can run the next one with a user that can sudo
```sh
sudo bash -c 'curl -sSL https://github.com/gardient/mailserver/raw/main/install | bash'
```
