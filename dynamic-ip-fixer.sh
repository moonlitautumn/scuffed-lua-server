#! /bin/bash

sleeptimeidk="10s"

echo "this script will detect if your isp changes your public ip, saving the new ip in a txt file for easy access!"
echo "> it will wait $sleeptimeidk before checking again"
echo ""

while true; do
    ip=$(hostname -i)
    iptxt=$(cat currentip.txt)
    
    datee=$(date)
    
    if [ "$iptxt" = "$ip" ]; then
        echo "> ${datee}" 
        echo "current ip -> $iptxt"
        echo ""
    else
        echo "================"
        echo "ip was -> $iptxt"
        echo $ip > currentip.txt
        echo "it changed at -> ${datee}"
        echo "================"
        # TO BE SETUP ONCE THE SERVER HAS AN API
        echo "atempting to change dns ip via api.... (not really yet)"
        #curl add-api-call-function-here
    
    fi

    sleep $sleeptimeidk
    
done
