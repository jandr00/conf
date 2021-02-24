#!/usr/bin/bash
mkdir ~/encryptedGit
cd ~/encryptedGit
touch clean_filter_openssl smudge_filter_openssl diff_filter_openssl 
chmod 755 *




cat << 'EOF' >> clean_filter_openssl
#!/bin/bash

SALT_FIXED=<your-salt> # 24 or less hex characters
PASS_FIXED=<your-passphrase>

openssl enc -base64 -aes-256-ecb -md sha512 -pbkdf2 -iter 100000 -S $SALT_FIXED -k $PASS_FIXED
EOF




cat << 'EOF' >> smudge_filter_openssl
#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED=<your-passphrase>

# If decryption fails, use 'cat' instead. 
# Error messages are redirected to /dev/null.
openssl enc -d -base64 -aes-256-ecb -md sha512 -pbkdf2 -iter 100000 -k $PASS_FIXED 2> /dev/null || cat
EOF





cat << 'EOF' >> diff_filter_openssl
#!/bin/bash

# No salt is needed for decryption.
PASS_FIXED=<your-passphrase>

# Error messages are redirect to /dev/null.
openssl enc -d -base64 -aes-256-ecb -md sha512 -pbkdf2 -iter 100000 -k $PASS_FIXED -in "$1" 2> /dev/null || cat "$1"
EOF


echo "##########"
echo GIT CLONNING:
echo echo git clone ....
echo cd git
echo rm -fr *
echo git reset --hard HEAD  
echo git pull

