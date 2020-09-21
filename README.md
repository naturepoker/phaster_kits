# phaster_kits

Quality of life improvement scripts for working with https://phaster.ca (PHAge Search Tool Enhanced Release)

Phaster is a web service for identifying and annotating prophage sequences within a given genome, supplied as a fasta or a genbank file.
Here's a reference describing what it actually does: https://doi.org/10.1093/nar/gkw387 

**Arndt D, Grant JR, Marcu A, Sajed T, Pon A, Liang Y, Wishart DS. PHASTER: a better, faster version of the PHAST phage search tool. Nucleic acids research. 2016 May 3;44(W1):W16-21.**

I found this service extremely handy for getting a general survey of prophage presence, and would recommend it heartily to anyone who wants to get a start at a general survey of prophages in whatever the dataset they are working with. 

For now the kit consists of just three scripts (based on bash) 

- *phaster_singlecontig.sh* for uploading all single contig fna genomes in the directory to the phaster service (chances are you'll want to use this if the survey targets are individual plasmids). After the submissions are complete you'll end with a concatenated list of Phaster query ids usually starting with ZZ- individual json feedback files from the Phaster servers are deleted via simple rm command at the end, which you can comment out if you want the full response files around. 

- *phaster_multicontig.sh* essentially the same script as above, except it notifies the server that the submissions are multicontig genomes. 

- *phaster-status.sh* this is the status checker script - larger submissions to the Phaster servers can take a significant length of time to process. You might want to run this script in the same directory as either one of the above two submission scripts, both of which will either generate a full .out json response file for each of the query made, or a concatenated phaster-queries.id file depending on what you chose (default behavior for the scripts are to generate one phaser.queries.id file containing all of the submissions). This script will take either the individual .out files or the phaser-queries.id file, return the total number of query IDs being tracking, check for their status - and simply return the wait count for the ID among the batch that has the highest wait time. All of the individual status returns are initially saved as individual 'queryid'.stat files first, which are concatenated and selected for highest wait time estimate. So if you'd like to save all of the json state returns and browse them individually you can simply quote out the last rm line as with the submission scripts. I am working on an improved version of the status checker that will simply create a tsv matching query ids to wait times every time the script is run, along with organizing data output once the server processes are done.  

To get these script working, simply chmod +ux them on the command line and execute as any other bash script. 
