#!/bin/bash

export $(cat .env)
API_URL="https://api.name.com"

old_address="$(curl -s ifconfig.me)"

records="$(curl -s -u $API_USER:$API_TOKEN \
    -H "Content-Type: application/json" \
 "$API_URL/v4/domains/nollium.com/records" | jq )"


fqdn_to_search="oracle.nollium.com."

echo "Watching $fqdn_to_search .."

domain_id=`echo "$records" | jq -r ".[][] | select(.fqdn == \"$fqdn_to_search\") | .id"`

while true; do

    records="$(curl -s -u $API_USER:$API_TOKEN \
        -H "Content-Type: application/json" \
    "$API_URL/v4/domains/nollium.com/records" | jq )"

    record_address=`echo "$records" | jq -r ".[][] | select(.fqdn == \"$fqdn_to_search\") | .answer"`

    current_address="$(curl -s ifconfig.me)"
    if [ "$record_address" != "$current_address" ]; then
        echo "IP address changed from $record_address to $current_address"
        #   /v4/domains/{domainName}/records/{id}
        #   {
        #       "id": 12345,
        #       "domainName": "example.org",
        #       "host": "www",
        #       "fqdn": "www.example.org",
        #       "type": "A",
        #       "answer": "10.0.0.1",
        #       "ttl": 300
        #   }					
        curl -s -u $API_USER:$API_TOKEN \
            -H "Content-Type: application/json" \
            -X PUT \
            -d "{\"answer\": \"$current_address\"}" \
            "$API_URL/v4/domains/nollium.com/records/$domain_id"

    fi
    sleep 10
done