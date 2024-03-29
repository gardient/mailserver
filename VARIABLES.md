# Variables

The following are the environment variables that can be configured ahead of time

They will be read from the environment

Don't forget to `export` them

```sh
$MAILSRV_DB_SA_PASSW
$MAILSRV_FQDN
$MAILSRV_MAIL_DOMAIN
$MAILSRV_POSTFIX_ADM_SETUP_PASSW
$MAILSRV_WEBMSTR_PASSW
```

If you want to have a truly headless instalation you will have to define them all

# Generated passwords

In addition you can use the following to not generate the DB passwords for the
service accounts used

```sh
$MAILSRV_SA_DOVECOT_RO_PASSW
$MAILSRV_SA_POSTFIXADM_RW_PASSW
$MAILSRV_SA_POSTFIX_RO_PASSW
$MAILSRV_SA_RC_PASS_RW_PASSW
$MAILSRV_SA_ROUNDCUBE_RW_PASSW
```

# Installer overwrites

the following overwrites the bootstrappers behaviour

```sh
$MAILSRV_INSTALL_DIR
$MAILSRV_INSTALL_GIT_REMOTE
$MAILSRV_INSTALL_USE_BRANCH
$MAILSRV_INSTALL_USE_TAG
```

# database name overrides

the following overwrites the default database names

```sh
$MAILSRV_DBNAME_POSTFIX
$MAILSRV_DBNAME_RCMAIL
```

and the usernames

```sh
$MAILSRV_DBUSERNAME_DB_SA
$MAILSRV_DBUSERNAME_SA_DOVECOT_RO
$MAILSRV_DBUSERNAME_SA_POSTFIXADM_RW
$MAILSRV_DBUSERNAME_SA_POSTFIX_RO
$MAILSRV_DBUSERNAME_SA_RC_PASS_RW
$MAILSRV_DBUSERNAME_SA_ROUNDCUBE_RW
```
