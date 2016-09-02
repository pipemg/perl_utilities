#!/usr/bin/perl -w


#IF NOT INSTALLED, INSTALL PERL MODULES
# IN BASH:
# $ sudo su
# $ perl -MCPAN -e shell
# cpan> install XML::Simple
# cpan> install Data::Dumper
# cpan> install Data::Dump
# cpan> exit
# $ exit


#LOAD ALL THE MODULES OF PERL
use strict;
use XML::Simple;
use Data::Dumper;
use Data::Dump qw(dump);

#DEFINE THE FUNCTION THAT WILL DUMP THE ARRAYS INTO STRINGS
sub array_dumper {
	#DUMP ARRAYS
	my $string=dump(@_);
	#GET NULL FIELDS
	if($string eq "{}"){
		return("Null");
	}
	if($string eq "undef"){
		return("Null");
	}	
	
	
	#REMOVE NEW LINES, AND "[]"
	$string=~s/\n|\[|\]|//gi;
	#CHANGE FILED SEPARATOR TO ;
	$string=~s/",  "/";"/gi;
	#REMOVE FINAL , IF EXISTS
	$string=~s/,$//;
	return($string);
}
  
  
  
  sub protein_dumper {
	#DUMP ARRAYS
	my $string=Dumper(@_);
	#GET NULL FIELDS
	
	$string=~s/},\n +{\n +//gi;
	$string=~s/ +//gi;
		
	return(split(/\n/,$string));
}
  
  
  
#CHANGE FOLDER
chdir("hmdb");
  
#CREATE AND OPEN THE OUTPUT FILE
#open(OUT, ">hmdb_proteins.tsv")||die ("hmdb_proteins.tsv wasn't created");  

  
#PRINT THE HEADER TO THE FILE
#print OUT ("\n");
#binmode(OUT, ":utf8");


#RPARSE EACH FILE USING XML::SIMPLE
my $xml = new XML::Simple;  
my $data = $xml->XMLin("hmdb_proteins.xml", KeyAttr => []);
print Dumper($data);
	

#close(OUT);


#THIS HELPS TO THE DESCRIPTION OF THE FILE, IN THIS CASE IS COMMENTED BEACUSE IT WAS ANALYZED BEFORE

