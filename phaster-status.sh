#!/usr/bin/env bash

#Script for extracting job ID for submitted Phaster queries and checking their status
#The script simply screens for all .out files in the directory

echo "                                                   "
echo "###################################################"
echo "##  Phaster submission status checker v. x.xx    ##"
echo "###################################################"
echo "                                                   "
echo "-----Binomica Labs - Small Thoughtful Science -----"
echo "                                                   "

query=./phaster-queries.id

if [ -f "$query" ]; then 
	echo "Phaster query ID file found. Checking status"
else
	cat *.out | tr -s '}' '\n' | awk -F: '{print $2}' | tr -d '"' | cut -d ',' -f1 > phaster-queries.id
	echo "Phaster query ID file created. Checking status"
fi

#Displaying total query ID count

query_count=$(cat phaster-queries.id | wc -l)

echo "###################################################"
echo "        $query_count Phaster query IDs found.      "
echo "###################################################"

#Applying each Phaster ID in the previous list to the URL query

for phasterid in $(cat phaster-queries.id); do
	wget "http://phaster.ca/phaster_api?acc=${phasterid}" -O $phasterid.stat
done

#Concatenating .stat files for the longest wait time

echo "###################################################"
echo "                                                   "
echo "                                                   "

cat *.stat | tr -s '}' '\n' | awk -F: '{print $3}' | tr -d '"' | sort -rd | head -n1

#Removing all .stat files to declutter the directory
#Since the .out files are still preserved, backups should be available if necessary

rm *.stat
