#! /bin/bash

while true; do
    ip=$(hostname -i)
    iptxt=$(cat currentip.txt)
    
    datee=$(date)
    
    if [ "$iptxt" = "$ip" ]; then
        echo "the ip didnt change!! current time: ${datee}" 
    else
        echo $ip > currentip.txt
        echo "it changed at: ${datee}"
        echo "ip is now: $iptxt"
        
        # TO BE SETUP ONCE THE SERVER HAS AN API
        echo "atempting to change dns ip via api...."
        #curl add-api-call-function-here
    
    fi

    sleep 60s
    
done
