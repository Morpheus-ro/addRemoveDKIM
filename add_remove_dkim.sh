#!/bin/bash

PATH1='/etc/opendkim/TrustedHosts'
PATH2='/etc/opendkim/KeyTable'
PATH3='/etc/opendkim/SigningTable'

while true
do
echo "What do you like to do?"
echo "1) add website to DKIM"
echo "2) remove website from DKIM"
echo "3) exit"
read case;
#simple case bash structure
# note in this case $case is variable and does not have to
# be named case this is just an example
case $case in
    1) echo "what is the domain that you want to add?"
	echo 'Insert domain: '
	read DOMAIN

	echo "Your domain is: " $DOMAIN

	if grep -Fq $DOMAIN $PATH1
	then
        	echo $DOMAIN ' was found in TrustedHosts'
	else
        	echo 'adding domain to ' $PATH1
	        echo '*.'$DOMAIN >> $PATH1
	fi
	if grep -Fq $DOMAIN $PATH2
	then
        	echo $DOMAIN ' was found in KeyTable'
	else
	        echo 'adding domain to ' $PATH2
        	echo 'mail._domainkey.'$DOMAIN' '$DOMAIN':mail:/etc/opendkim/keys/'$DOMAIN'/mail.private' >> $PATH2
	fi
	if grep -Fq $DOMAIN $PATH3
	then
	        echo $DOMAIN ' was found in SigningTable'
	else
	        echo 'adding domain to ' $PATH3
        	echo '*@'$DOMAIN' mail._domainkey.'$DOMAIN >> $PATH3
	fi

	if [ -d "/etc/opendkim/keys/$DOMAIN" ] 
	then
        	echo "Directory /etc/opendkim/keys/$DOMAIN exists"
	else
        	mkdir "/etc/opendkim/keys/$DOMAIN"
	        echo "Directory /etc/opendkim/keys/$DOMAIN created"
        	cd "/etc/opendkim/keys/$DOMAIN"
	        opendkim-genkey -s mail -d $DOMAIN
		chown opendkim:opendkim -R /etc/opendkim/keys/$DOMAIN
        	cat mail.txt
	fi

        service postfix restart
        service opendkim restart

	;;
    2) echo "What is the domain you want to remove?"
	echo 'Insert domain: '
        read DOMAIN
	
        echo "Removing domain: " $DOMAIN
	
	cp $PATH1 "$PATH1.bkp"
	cat /dev/null > $PATH1
	cat "$PATH1.bkp" | grep -iv $DOMAIN >> $PATH1
	
	cp $PATH2 "$PATH2.bkp"
        cat /dev/null > $PATH2
        cat "$PATH2.bkp" | grep -iv $DOMAIN >> $PATH2
	
	cp $PATH3 "$PATH3.bkp"
        cat /dev/null > $PATH3
        cat "$PATH3.bkp" | grep -iv $DOMAIN >> $PATH3
	
	rm -rf "/etc/opendkim/keys/$DOMAIN"

	service postfix restart
	service opendkim restart

	echo "Domain $DOMAIN removed"
	;;
    3) exit
esac
done
