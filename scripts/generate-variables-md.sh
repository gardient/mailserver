#!/usr/bin/env bash

vars=$(egrep -rsho '\$MAILSRV_[[:alpha:]_]+' . | sort | uniq)

cat <<- EOF
# Variables

The following are the environment variables that can be configured ahead of time

They will be read from the environment

Don't forget to \`export\` them

\`\`\`sh
$(fgrep -v -e 'MAILSRV_SA_' -e 'MAILSRV_INSTALL_' -e 'MAILSRV_DBNAME_' <<< "$vars")
\`\`\`

If you want to have a truly headless instalation you will have to define them all

# Generated passwords

In addition you can use the following to not generate the DB passwords for the
service accounts used

\`\`\`sh
$(fgrep 'MAILSRV_SA_' <<< "$vars")
\`\`\`

# Installer overwrites

the following overwrites the bootstrappers behaviour

\`\`\`sh
$(fgrep 'MAILSRV_INSTALL_' <<< "$vars")
\`\`\`

# database name overrides

the following overwrites the default database names

\`\`\`sh
$(fgrep 'MAILSRV_DBNAME_' <<< "$vars")
\`\`\`
EOF
