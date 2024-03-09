#!/bin/bash

# Cloudflare API Token (keep this private!)
CLOUDFLARE_API_TOKEN=""

# Clourdflare Zone ID (find this in your Cloudflare dashboard)
ZONE_ID=""

# DNS record to update (e.g., ddns.example.com)
DNS_RECORD=""

# Choose whetehr to use internal or external IP
WHAT_IP="external" #Options: "internal" or "external"

# Cloudflare options
PROXIED=false # Set to true if you want to use Cloudflare proxy

TTL=120       #TTL in seconds (or 1 for auto)

# Check if the IP has changed
CURRENT_IP=$(curl -s https://api.ipify.org)
LAST_IP=$(cat /tmp/last_ip.txt 2>/dev/null)

if [ "$CURRENT_IP" != "$LAST_IP" ]; then
    #Update Cloudflare DNS record
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$DNS_RECORD\",\"content\":\"$CURRENT_IP\",\"proxied\":$PROXIED,\"ttl\":$TTL}"

    # SAve the current IP for future comparison
    echo "$CURRENT_IP" > /tmp/last_ip.txt
    echo "IP address updated to $CURRENT_IP"
else
    echo "IP address updated to $CURRENT_IP"
fi