#!/usr/bin/env bash

#Script for extracting job ID for submitted Phastest queries and checking their status
#The script simply screens for all .out files in the directory

echo "                                                   "
echo "###################################################"
echo "##  Phastest submission status checker v. x.xx   ##"
echo "###################################################"
echo "                                                   "
echo "-----Binomica Labs - Small Thoughtful Science -----"
echo "                                                   "

#Declaring today's date as a variable for final output file

today=$(date +%m_%d_%Y)

#Bringing in Phastest queries id file for further processing
#If the queries file is not found, the script will look for individual outputs from previous script

query=./phastest-queries.id

if [ -f "$query" ]; then
	echo "Phastest query ID file found. Checking status"
else
	cat *.out | tr -s '}' '\n' | awk -F: '{print $2}' | tr -d '"' | cut -d ',' -f1 > phastest-queries.id
	echo "Phastest query ID file created. Checking status"
fi

#Displaying total query ID count

query_count=$(cat phastest-queries.id | wc -l)

echo "###################################################"
echo "       $query_count Phastest query IDs found.      "
echo "###################################################"

#Applying each Phaster ID in the previous list to the URL query

for phastestid in $(cat phastest-queries.id); do
	wget "https://phastest.ca/phastest_api?acc=${phastestid}" -O $phastestid.stat
done

#Concatenating .stat files for the longest wait time

echo "###################################################"
echo "                                                   "
echo "                                                   "

cat *.stat | tr -s '}' '\n' | awk -F: '{print $3}' | tr -d '"' | sort -rd | head -n1

#Saving concantenated list of phastest query responses as a single file 

grep -i "status" *.stat > "$today"_queries.list

#Removing all the individual .stat query output to tidy up the directory

rm *.stat


