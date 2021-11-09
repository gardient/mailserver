#!/usr/bin/env bash

cat <<- EOF
# Variables

The following are the environment variables that can be configured ahead of time

They will be read from the environment

Don't forget to \`export\` them

\`\`\`sh
$(egrep -rsho '\$MAILSRV_[[:alpha:]_]+' . | sort | uniq | fgrep -v 'MAILSRV_SA_')
\`\`\`

If you want to have a truly headless instalation you will have to define them all

# Generated passwords

In addition you can use the following to not generate the DB passwords for the
service accounts used

\`\`\`sh
$(egrep -rsho '\$MAILSRV_[[:alpha:]_]+' . | sort | uniq | fgrep 'MAILSRV_SA_')
\`\`\`
EOF
