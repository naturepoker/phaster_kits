#!/usr/bin/env bash

#This script acts on all .fna files in the directory!
#Only for multicontig genomes

echo "                                                 "
echo "#################################################"
echo "-Welcome to Phaster multicontig genome submitter-"
echo "-------------------------------------------------"
echo "!This script submits all .fna in local directory!"
echo "#################################################"
echo "                                                 "

#Checking for the presence of output query id file
#And tallying up the total number of .fna genomes in the directory for submission

genomes="$(ls -1 *.fna | wc -l)"
query=./phaster-queries.id

if [ -f "$query" ]; then
        echo "Phaster ID list found. Please check if you already submitted your genomes to Phaster."
	exit
else
	echo "                                                    "
	echo "$genomes FASTA files found in directory. Submitting."
	echo "                                                    "
fi

#Submitting all .fna files in the directory to Phaster
#All submission confirmation files returned as genome name.out

for F in *.fna; do
N=$(basename $F .fna);
wget --post-file="$F" "http://phaster.ca/phaster_api" -O $N.out; 
done

echo "                                                  "
echo "                                                  "
echo "##################################################"
echo "# All genomes in directory submitted to Phaster. #"
echo "##################################################"
echo "                                                  "
echo "                                                  "

#Sorting through .out files to extract query IDs

cat *.out | tr -s '}' '\n' | awk -F: '{print $2}' | tr -d '"' | cut -d ',' -f1 > phaster-queries.id

echo "##############################"
echo "Phaster query ID list created."
echo "       Have a nice day!       "
echo "##############################"



