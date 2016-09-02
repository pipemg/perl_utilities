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
open(OUT, ">hmdb_metabolites.tsv")||die ("hmdb_metabolties.tsv wasn't created");  

  
#PRINT THE HEADER TO THE FILE
print OUT ("#accession\tname\tsecondary_accessions\tiupac_name\tchemical_formula\tdescription\tsynonyms\tdrugbank\tdrugbank_metabolite\tinchi\tinchikey\tpubchem\tchebi\tkegg_id\tmetlin\ttraditional_iupac\tmonisotopic\tcreation\tnugowiki\tweight\tversion\tpubmed\tprotein_names\tprotein_accession\tprotein_type\tuniprot_id\tupdate_date\tcas_registry_number\tchemspider_id\n");
binmode(OUT, ":utf8");

#READ ALL THE METABOLITE FILES
my @metabolite_files=`ls hmdb_metabolites/HMDB*`;



for(my $i=0; $i<scalar(@metabolite_files); $i++){

  	$metabolite_files[$i]=~s/\n//gi;
  	#print($i." - ".$metabolite_files[$i]."\n");
  
  	#RPARSE EACH FILE USING XML::SIMPLE
	my $xml = new XML::Simple;  
	my $data = $xml->XMLin($metabolite_files[$i], KeyAttr => []);;
	#print Dumper($data);
	
	#GET THE DATA OF INTEREST
	my $accession = $data->{accession};
	my $secondary_accessions = array_dumper($data->{secondary_accessions}->{accession});
	my $name = array_dumper($data->{name});
	my $iupac_name = $data->{iupac_name};
	my $chemical_formula = $data->{chemical_formula};
	my $description = $data->{description};
	$description =~s/\n//gi;
	
	my $synonyms= array_dumper($data->{synonyms}->{synonym});
	my $drugbank = array_dumper($data->{drugbank_id});
	my $drugbank_metabolite = array_dumper($data->{drugbank_metabolite_id});
	my $inchi = array_dumper($data->{inchi});
	my $inchikey = array_dumper($data->{inchikey});
	my $pubchem = array_dumper($data->{pubchem_compound_id});
	my $chebi = array_dumper($data->{chebi_id});
	my $kegg_id = array_dumper($data->{kegg_id});
	my $biocyc = array_dumper($data->{biocyc_id});
	my $metlin= array_dumper($data->{metlin_id});
	my $traditional_iupac = array_dumper($data->{traditional_iupac});
	#my $normal_concentrations = array_dumper($data->{normal_concentrations});
	my $monisotopic = array_dumper($data->{monisotopic_moleculate_weight});
	my $creation = array_dumper($data->{creation_date});
	my $nugowiki = array_dumper($data->{nugowiki});
	my $weight = array_dumper($data->{average_molecular_weight});
	#my $synthesis = array_dumper($data->{synthesis_reference});
	#my $pathways = array_dumper($data->{pathways});
	#my $references= array_dumper($data->{general_references}->{reference});
	my $version= array_dumper($data->{version});
	
	my $pubmed="";
	my $temp_ref=dump($data->{general_references});
	$temp_ref=join(";",grep(/pubmed_id/,split(/\n/,$temp_ref)));
	$temp_ref=~s/,; +pubmed_id => +/;/gi;
	$temp_ref=~s/,$//;
	$temp_ref=~s/ +pubmed_id => //;
 	$pubmed=$temp_ref;

	#my @protein_array=split(/\n/,
	my @p_dumed=protein_dumper($data->{protein_associations}->{protein});
	my $protein_names = join(";",grep(/'name'/,@p_dumed));
	$protein_names=~s/',/'/gi;
	$protein_names=~s/'name'=>//gi;

	my $protein_accession = join(";",grep(/'protein_accession'/,@p_dumed));
	$protein_accession=~s/',/'/gi;
	$protein_accession=~s/'protein_accession'=>//gi;
		
	my $protein_type = join(";",grep(/'protein_type'/,@p_dumed));
	$protein_type=~s/',/'/gi;
	$protein_type=~s/'protein_type'=>//gi;
		
	my $uniprot_id = join(";",grep(/'uniprot_id'/,@p_dumed));
	$uniprot_id=~s/',/'/gi;
	$uniprot_id=~s/'uniprot_id'=>//gi;


	#my $diseases= array_dumper($data->{diseases});
	my $update_date= array_dumper($data->{update_date});
	my $cas_registry_number= array_dumper($data->{cas_registry_number});
	my $chemspider_id= array_dumper($data->{chemspider_id});	
	
	#PRINT THE VALUES TO THE FILE
	

	print OUT ("$accession\t$name\t$secondary_accessions\t");
	print OUT ("$iupac_name\t");
	print OUT ("$chemical_formula\t");
	print OUT ($description."\t");
	print OUT ("$synonyms\t$drugbank\t$drugbank_metabolite\t$inchi\t$inchikey\t$pubchem\t$chebi\tkegg_id\t$metlin\t$traditional_iupac\t$monisotopic\t$creation\t$nugowiki\t$weight\t$version\t$pubmed\t$protein_names\t$protein_accession\t$protein_type\t$uniprot_id\t$update_date\t$cas_registry_number\t$chemspider_id\n");

}
 
close(OUT);


#THIS HELPS TO THE DESCRIPTION OF THE FILE, IN THIS CASE IS COMMENTED BEACUSE IT WAS ANALYZED BEFORE






















