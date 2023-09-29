#!/bin/bash

ip_info=$(curl -s http://ipinfo.io/json)

# Extract city, region, country, and postal using Bash string manipulation
city=$(echo "$ip_info" | grep -o '"city": "[^"]*' | sed 's/"city": "//')
region=$(echo "$ip_info" | grep -o '"region": "[^"]*' | sed 's/"region": "//')
country=$(echo "$ip_info" | grep -o '"country": "[^"]*' | sed 's/"country": "//')
postal=$(echo "$ip_info" | grep -o '"postal": "[^"]*' | sed 's/"postal": "//')

loc="$city, $region, $country, $postal"

echo "Setting Custom14 to $loc"

org=$(echo "$ip_info" | grep -o '"org": "[^"]*' | sed 's/"org": "//')
echo "Setting Custom13 to $org"

XMLPath=$(find /root/.mono/registry -name "values.xml")
XMLTemp=$(cat $XMLPath | grep -v "</values>")
XMLTemp="$XMLTemp"$'\n'"<value name=\"Custom13\" type=\"string\">$loc</value>"$'\n'"</values>"
rm $XMLPath
echo "$XMLTemp" >> $XMLPath

XMLPath=$(find /root/.mono/registry -name "values.xml")
XMLTemp=$(cat $XMLPath | grep -v "</values>")
XMLTemp="$XMLTemp"$'\n'"<value name=\"Custom14\" type=\"string\">$org</value>"$'\n'"</values>"
rm $XMLPath
echo "$XMLTemp" >> $XMLPath

echo "UDF values updated successfully."
exit 0
