#!/usr/bin/env bash

#This script acts on all .fna files in the directory!
#Only for multicontig genomes

echo "                                                 "
echo "#################################################"
echo "Welcome to Phastest multicontig genome submitter "
echo "-------------------------------------------------"
echo "!This script submits all .fna in local directory!"
echo "#################################################"
echo "                                                 "

#Checking for the presence of output query id file
#And tallying up the total number of .fna genomes in the directory for submission

genomes="$(ls -1 *.fna | wc -l)"
query=./phastest-queries.id

if [ -f "$query" ]; then
        echo "Phastest ID list found. Please check if you already submitted your genomes to Phastest."
	exit
else
	echo "                                                    "
	echo "$genomes FASTA files found in directory. Submitting."
	echo "                                                    "
fi

#Submitting all .fna files in the directory to Phastest
#All submission confirmation files returned as genome name.out

for F in *.fna; do
N=$(basename $F .fna);
wget --post-file="$F" "https://phastest.ca/phastest_api?contigs=1" -O $N.out;
done

echo "                                                  "
echo "                                                  "
echo "##################################################"
echo "# All genomes in directory submitted to Phastest #"
echo "##################################################"
echo "                                                  "
echo "                                                  "

#Sorting through .out files to extract query IDs

cat *.out | tr -s '}' '\n' | awk -F: '{print $2}' | tr -d '"' | cut -d ',' -f1 > phastest-queries.id

echo "##############################"
echo "Phastest query ID list created"
echo "       Have a nice day!       "
echo "##############################"



