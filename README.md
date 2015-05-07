# addRemoveDKIM
Bash script to add or remove openDKIM from TrustedHosts, KeyTable, SigningTable, opendkim keys on Ubuntu 14.04

./addRemoveDKIM

What do you like to do?
1) add website to DKIM
2) remove website from DKIM
3) exit

Insert domain to add: 

example.com

add new line in /etc/opendkim/TrustedHosts -> *.example.com
add new line in /etc/opendkim/KeyTable -> mail._domainkey.example.com example.com:mail:/etc/opendkim/keys/example.com/mail.private
add new line in /etc/opendkim/SigningTable -> *@example.com mail._domainkey.example.com

Generating the keys in /etc/opendkim/keys/example.com -> /etc/opendkim/keys/example.com and the shows mail.txt content in order to copy the key in DNS

Restarts postfix and opendkim service


