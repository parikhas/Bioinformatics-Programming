PROGRAM: getGeneInfo.pl

DESCRIPTION

This program uses data from the Unigene database from six different mammals and queries the tissue expression for a given gene and species.

REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid file.

FEATURES

This program uses a Module MyIO.pm to open files.
It uses a configuration module Config.pm to configure the data needed for the program.
It has 5 subroutines:

1) modifyHostName : 
This subroutine receives one argument: 1). A host name. It takes the host name and checks for the available conversions from common to scientific names and return the scientific name. 
This subroutine calls getHostKeywords to get the reference to the hash of mapped terms from the Assignment5::Config.pm module. 
If the host passed in does not exist then it calls the subroutine _printHostDirectoriesWhichExist to alert the user what directories do exist. 

2) isValidGeneFileName
It receives one argument. 1). A file name. This subroutine will check to make sure the given file name exists, if it does it return 1; else it will return; 

3)_printHostDirectoriesWhichExist
It receives 0 arguments and is called from modifyHostName. If the user asks for a directory that does not exist, the function prints out the host directories which do exist. 
If _printHostDirectoriesWhichExist is called, it exits the program

4)getGeneData
It receives two arguments: 1). A gene name. 2). A host name. It opens the file for the host and gene, extracts the list of tissues in which this gene is expressed and returns a reference to a sorted array of the tissues.

5)call it printOutput
It receives three arguments: 1). The gene name searched. 2). The host name given at the CLI. 3). An array reference which was returned from getGeneData. 
This subroutine prints the tissue expression data for the gene. 

OPERATING INSTRUCTIONS

To use this program, you have to give the input of the host and the gene whose data we want. 
Ex. If the host organism is horse and the gene is API5, then we write the following on the command line:
perl categories.pl -host horse -gene API5 

It will give the output: 
Found Gene API5 for Equus caballus
In Equus caballus, There are 3 tissues that API5 is expressed in:

  1. Adult
  2. Blood
  3. Cartilage

If no host and gene is specified, then it will give the information for the host human and gene TGM1.

For more details and explanations, please refer to the source code.