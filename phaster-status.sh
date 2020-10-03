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

#Declaring today's date as a variable for final output file 

today=$(date +%m_%d_%Y)

#Bringing in Phaster queries id file for further processing
#If the queries file is not found, the script will look for individual outputs from previous script

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

#Saving concantenated list of phaster query responses as a single file 

grep -i "status" *.stat > "$today"_queries.list

#Removing all the individual .stat query output to tidy up the directory

rm *.stat


