#!/bin/bash
content="

  Postfix configuration for use with PostfixAdmin

-----------------------

  Your installation of Postfix MUST support either MySQL or Postgres
lookup tables.  You can verify that with 'postconf -m'

Its generally recommended to use proxy as well (which should also appear in
postconf -m)  Three main.cf variables are involved:

virtual_mailbox_domains = proxy:mysql:/etc/postfix/sql/mysql_virtual_domains_maps.cf
virtual_alias_maps =
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_maps.cf,
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_maps.cf,
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_catchall_maps.cf
virtual_mailbox_maps =
   proxy:mysql:/etc/postfix/sql/mysql_virtual_mailbox_maps.cf,
   proxy:mysql:/etc/postfix/sql/mysql_virtual_alias_domain_mailbox_maps.cf

# For transport map support, also use the following configuration:

relay_domains = proxy:mysql:/etc/postfix/sql/mysql_relay_domains.cf
transport_maps = proxy:mysql:/etc/postfix/sql/mysql_transport_maps.cf

# Also set the config.inc.php setting transport=YES
# and add the transport choices to transport_options.

# if you let postfix store your mails directly (without using maildrop, dovecot deliver etc.)
virtual_mailbox_base = /var/mail/vmail
# or whereever you want to store the mails

Where you chose to store the .cf files doesn't really matter, but they will
have database passwords stored in plain text so they should be readable only
by user postfix, or in a directory only accessible to user postfix.

This isn't necessarily all you need to do to Postfix to get up and
running.  Also, additional changes are needed for the vacation
autoreply features.

-------------------------

  Contents of the files

These are examples only, you will likely have to and want to make some
customizations.  You will also want to consider the config.inc.php
settings for domain_path and domain_in_mailbox.  These examples
use values of domain_path=YES and domain_in_mailbox=NO

You can create these files (with your values for user, password, hosts and
dbname) automatically by executing this file (sh POSTFIX_CONF.txt).
Please note that the generated files are for use with MySQL.

If you are using PostgreSQL, you'll need to do some changes to the queries:
- PostgreSQL uses a different implementation for boolean values, which means
  you'll need to change  active='1'  to  active='t'  in all queries
- PostgreSQL does not have a concat() function, instead use e.g.
  .... alias.address = '%u' || '@' || alias_domain.target_domain AND ....


mysql_virtual_alias_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT goto FROM alias WHERE address='%s' AND active = '1'
#expansion_limit = 100

mysql_virtual_alias_domain_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT goto FROM alias,alias_domain WHERE alias_domain.alias_domain = '%d' and alias.address = CONCAT('%u', '@', alias_domain.target_domain) AND alias.active='1' AND alias_domain.active='1'

mysql_virtual_alias_domain_catchall_maps.cf:
# handles catch-all settings of target-domain
user = postfix
password = password
hosts = localhost
dbname = postfix
query  = SELECT goto FROM alias,alias_domain WHERE alias_domain.alias_domain = '%d' and alias.address = CONCAT('@', alias_domain.target_domain) AND alias.active='1' AND alias_domain.active='1'

(See above note re Concat + PostgreSQL)

mysql_virtual_domains_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query          = SELECT domain FROM domain WHERE domain='%s' AND active = '1'
#query          = SELECT domain FROM domain WHERE domain='%s'
#optional query to use when relaying for backup MX
#query           = SELECT domain FROM domain WHERE domain='%s' AND backupmx = '0' AND active = '1'
#optional query to use for transport map support
#query           = SELECT domain FROM domain WHERE domain='%s' AND active = '1' AND NOT (transport LIKE 'smtp%%' OR transport LIKE 'relay%%')
#expansion_limit = 100

mysql_virtual_mailbox_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query           = SELECT maildir FROM mailbox WHERE username='%s' AND active = '1'
#expansion_limit = 100

mysql_virtual_alias_domain_mailbox_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT maildir FROM mailbox,alias_domain WHERE alias_domain.alias_domain = '%d' and mailbox.username = CONCAT('%u', '@', alias_domain.target_domain) AND mailbox.active='1' AND alias_domain.active='1'

mysql_relay_domains.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT domain FROM domain WHERE domain='%s' AND active = '1' AND (transport LIKE 'smtp%%' OR transport LIKE 'relay%%')

mysql_transport_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT transport FROM domain WHERE domain='%s' AND active = '1' AND transport != 'virtual'


(See above note re Concat + PostgreSQL)

# For quota support

mysql_virtual_mailbox_limit_maps.cf:
user = postfix
password = password
hosts = localhost
dbname = postfix
query = SELECT quota FROM mailbox WHERE username='%s' AND active = '1'

-------------------------

  More information - HowTo docs that use PostfixAdmin

http://postfix.wiki.xs4all.nl/index.php?title=Virtual_Users_and_Domains_with_Courier-IMAP_and_MySQL
http://wiki.dovecot.org/HowTo/DovecotLDAPostfixAdminMySQL

" # end content

# this is based on https://github.com/postfixadmin/postfixadmin/blob/master/DOCUMENTS/POSTFIX_CONF.txt

map_files="$(sed -n '/^mysql.*cf:/ s/://p' <<< "$content")"

tmpdir="$1"

mkdir "$tmpdir"

for file in $map_files ; do
	(
		echo "# $file"
		sed -n "/$file:/,/^$/ p" <<< "$content" | sed "
			1d ; # filename
			s/^user =.*/user = $MAILSRV_DBUSERNAME_SA_POSTFIX_RO/ ;
			s/^password =.*/password = $MAILSRV_SA_POSTFIX_RO_PASSW/ ;
			s/^hosts =.*/hosts = 127.0.0.1/ ;
			s/^dbname =.*/dbname = $MAILSRV_DBNAME_POSTFIX/ ;
		"
	) > "$tmpdir/$file"
done

