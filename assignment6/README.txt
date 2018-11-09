PROGRAM: snpScan.pl

DESCRIPTION

This program has three command line flags, one for the query file (-query), one for the eQTL data file (-eqtl), and one for the outfile (-outfile)
that is used to store the output from the program. 
The program utilizes a subroutine to store the site positions the biologist gave as input  in a hash of arrays,
A second subroutine reads in the eQTL dataset, stores the loci from the eQTL dataset in another hash of arrays, 
and stores the additional information for each eQTL in a hash of hashes. 
It also utilizes a third subroutine which then iterates through the array of your sites and finds the nearest eQTL to that site and generates the output in the named outfile given at the command line option.
We get an outfile containing the original query site, its distance to the nearest eQTL, the eQTL, and the gene information associated with that eQTL 

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid file.

FEATURES

This program uses a Module MyIO.pm to open files.
It uses a configuration module Config.pm to configure the data needed for the program.
It has 4 subroutines:

1. getQuerySites
Called in scalar context 
Receives one argument: 1). A file name for the input query. 
This subroutine opens a file handle, and with a while loop iterates over the query file and create a hash key for each chromosome with a value of an array of all of the positions for that chromosome. 
This subroutine returns a reference to the HoA. 

2. getEqtlSites
Called in scalar context
Receives one argument: 1). A file name for the eQTL dataset . 
This subroutine opens the eQTL dataset, and will iterate over the eQTL file and create a Hash of Arrays, with the hash key being each chromosome and the a value will be an array reference of all the positions for that chromosome. 
Simultaneously, it should create a Hash of Hashes, with the hash key being each chromosome, and the value is hash reference which has keys for each position and the values being the descriptions of the genes affected by the eQTL so this description can be called for and output in the final step. 
This subroutine will return the references to the two data structures created in this subroutine.

3. compareInputSitesWithQtlSites, 
Called in void context 
Receives four arguments: 1). A reference to the HoA in sub1. 
2). A reference to the HoA created in sub2. 
3). A reference to the HoH created in sub2. 
4). file name for the outfile passed into the command line options. 
This subroutine iterates over each site in the query sites hash and compares it to the sites in the eQTL hash to find the nearest site.
It prints to the outfile the original query site, its distance to the nearest eQTL, the eQTL, and the gene information associated with that eQTL in a tab-delimited fashion

4.  _findNearest
Called in scalar context 
Receives three arguments: 
1). A chromosome number 
2). A position on the chromosome number 
3). A reference to the HoA created in sub2. 
This subroutine finds the closest position on the same chromosome number, to the queried position and return that position. 
Returns void if no position number is found. 

OPERATING INSTRUCTIONS

To use this program, you have to give as input, the input query file, the eQTL dataset and the file you want to print the output to.

Run this program as
perl snpScan.pl -query input.txt -eqtl affy.dat -outfile scan.txt

For more details and explanations, please refer to the source code.