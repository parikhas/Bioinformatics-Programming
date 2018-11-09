PROGRAMS: kinaseMooseMap1.pl, kinaseMooseMap2.pl

DESCRIPTION

 
REQUIREMENTS

As this program is written in perl, the user should have perl installed on their system to execute it.
The file entered should be a valid file.

FEATURES

This program uses a Module MyIO.pm to open files.
It uses a configuration module Config.pm to configure the data needed for the program.

The methods used are:

_readKinases receives a file containing kinase info. It goes through the
field, creates an AoH, where each hash contains the kinase info for one line.
It then returns a reference to the AoH

The BUILD method is called after the object is constructed, but before it is returned to the caller. 
The BUILD method provides an opportunity to check the object state as a whole.  
This method, receives $self, so you can do a $self->filename to get the filename passed at construction. 
If a new object is created it was done via a filename passed in at construction, but a current instance of BioIO: MooseKinases.pm can create a new version of BioIO: MooseKinases.pm that's been filtered by filterKinases, so no file is passed in.

printKinases receives 2 args: a filename indicating output, and reference to an array, that's a 
list of fields. It prints all the kinases in a Kinases object, according to the
requested list of keys.

filterKinases receives a hash reference with field-criterion for filtering the Kinases of
interest. It returns a new Kinases object which contains the kinases meeting the requirement (filter parameters)
passed into the method.  This method uses named parameters, since you could
pass any of the keys to the hashes found in the AOH: symbol, name, location, date, omim_accession.
If no filters are passed in, then it would just return another Kinases object with all the same entries
This could be used to create an exact copy of the object. 

getAoh returns the attribute for aoh to get to the array of hashes in filterKinases, printKinases, and getElementInArray

getNumberOfKinases returns the attribute numberOfKinases in the Kinases object 

getElementInArray , takes one argument (an index) and return the element of the Array of Hashes stored in Kinases instance. 

OPERATING INSTRUCTIONS

Run thess programs as
perl kinaseMooseMap1.pl
perl kinaseMooseMap2.pl

For more details and explanations, please refer to the source code.
