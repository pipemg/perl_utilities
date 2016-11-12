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


#SPLIT THE XML FILE INTO FILES
# csplit -n4 -f protein hmdb_proteins.xml "/^<?xml version/" {*}

#LOAD ALL THE MODULES OF PERL
use strict;
use XML::Simple;
use Data::Dumper;
use Data::Dump qw(dump);


#VERBOSE OPTION
my $verbose = "yes"; 

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
  
  

  
  
    
#CHANGE FOLDER IF IS NEEDED
#chdir("hmdb");
  
  
#CREATE AND OPEN THE OUTPUT FILE
open(OUT, ">hmdb_proteins.tsv")||die ("hmdb_proteins.tsv wasn't created");  
binmode(OUT, ":utf8");
  
#PRINT THE HEADER TO THE FILE
print OUT ("version\tcreation_date\tupdate_date\taccession\tsecondary_accessions\tprotein_type\tsynonyms\tgene_name\tgeneral_function\tspecific_function\tpathways_names\tpathways_kegg_map_id\tmetabolite_hmdb\tmetabolite_name\tgo_category\tgo_description\tgo_id\tsubcellular_location\tgene_chromosome_location\tgene_chromosome_locus\tprotein_residue_number\tprotein_molecular_weight\tprotein_theoretical_pi\tprotein_pfams_pfam_name\tprotein_pfams_pfam_id\tgenbank_protein_id\tuniprot_id\tuniprot_name\tpdb_ids\tgenbank_gene_id\tgenecard_id\tgeneatlas_id\thgnc_id\tpubmed_id\tmetabolite_references_metabolite_accession\tmetabolite_references_pubmed_id\n");




#READ ALL THE METABOLITE FILES
my @protein_files=`ls hmdb_proteins/*`;

my @temp=();


for(my $i=0; $i<scalar(@protein_files); $i++){

  	$protein_files[$i]=~s/\n//gi;
  	if($verbose eq "yes"){
	  	print($i." - ".$protein_files[$i]."\n");
	 }
  
  	#RPARSE EACH FILE USING XML::SIMPLE
	my $xml = new XML::Simple;  
	my $data = $xml->XMLin($protein_files[$i], KeyAttr => []);;
	#print Dumper($data);
	my $version = array_dumper ($data->{version});
	my $creation_date = array_dumper ($data->{creation_date});
	my $update_date = array_dumper ($data->{update_date});
	my $accession = array_dumper ($data->{accession});
	my $secondary_accessions = array_dumper($data->{secondary_accessions}->{accession});
	my $protein_type = array_dumper ($data->{protein_type});
	my $synonyms= array_dumper($data->{synonyms}->{synonym});
	my $gene_name = array_dumper ($data->{gene_name});
	my $general_function = array_dumper ($data->{general_function});
	my $specific_function = array_dumper ($data->{specific_function});
	$specific_function=~s/[\n|\t]//gi;
	
	my $pathways_names=array_dumper($data->{pathways}->{pathway});
	$pathways_names=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$pathways_names);
	@temp=grep(/name =>/,@temp);
	$pathways_names=join(";",@temp);
	$pathways_names=~s/; +/;/gi;
	$pathways_names=~s/name => //gi;
	
	my $pathways_kegg_map_id=array_dumper($data->{pathways}->{pathway});
	$pathways_kegg_map_id=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$pathways_kegg_map_id);
	@temp=grep(/kegg_/,@temp);
	$pathways_kegg_map_id=join(";",@temp);
	$pathways_kegg_map_id=~s/; +/;/gi;
	$pathways_kegg_map_id=~s/kegg_map_id => ;/kegg_map_id =>Null/gi;
	$pathways_kegg_map_id=~s/kegg_map_id => //gi;

	my $metabolite_hmdb=array_dumper($data->{metabolite_associations}->{metabolite});
	$metabolite_hmdb=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$metabolite_hmdb);
	@temp=grep(/accession/,@temp);
	$metabolite_hmdb=join(";",@temp);
	$metabolite_hmdb=~s/; +/;/gi;
	$metabolite_hmdb=~s/accession => //gi;

	my $metabolite_name=array_dumper($data->{metabolite_associations}->{metabolite});
	$metabolite_name=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$metabolite_name);
	@temp=grep(/name/,@temp);
	$metabolite_name=join(";",@temp);
	$metabolite_name=~s/ ; +/;/gi;
	$metabolite_name=~s/name =>//gi;
			
	my $go_category=array_dumper($data->{go_classifications}->{go_class});
	$go_category=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$go_category);
	@temp=grep(/category/,@temp);
	$go_category=join(";",@temp);
	$go_category=~s/; +/;/gi;
	$go_category=~s/category => ;/category =>Null/gi;
	$go_category=~s/category =>//gi;		
			
	my $go_description=array_dumper($data->{go_classifications}->{go_class});
	$go_description=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$go_description);
	@temp=grep(/description/,@temp);
	$go_description=join(";",@temp);
	$go_description=~s/; +/;/gi;
	$go_description=~s/description => ;/description =>Null/gi;
	$go_description=~s/description =>//gi;							
			
	my $go_id=array_dumper($data->{go_classifications}->{go_class});
	$go_id=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$go_id);
	@temp=grep(/_id /,@temp);
	$go_id=join(";",@temp);
	$go_id=~s/; +/;/gi;
	$go_id=~s/go_id => ;/go_id =>Null/gi;
	$go_id=~s/go_id =>//gi;							
	
	my $subcellular_location=array_dumper($data->{subcellular_locations}->{subcellular_location});
	my $gene_chromosome_location=array_dumper($data->{gene_properties}->{chromosome_location});				
	my $gene_chromosome_locus=array_dumper($data->{gene_properties}->{locus});				

	my $protein_residue_number=array_dumper($data->{protein_properties}->{residue_number});				
	my $protein_molecular_weight=array_dumper($data->{protein_properties}->{molecular_weight});				
	my $protein_theoretical_pi=array_dumper($data->{protein_properties}->{theoretical_pi});				
		
	my $protein_pfams_pfam_name=array_dumper($data->{protein_properties}->{pfams}->{pfam});				
	$protein_pfams_pfam_name=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$protein_pfams_pfam_name);
	@temp=grep(/name/,@temp);
	$protein_pfams_pfam_name=join(";",@temp);
	$protein_pfams_pfam_name=~s/; +/;/gi;
	$protein_pfams_pfam_name=~s/name => ;/name =>Null/gi;
	$protein_pfams_pfam_name=~s/name =>//gi;
	
	my $protein_pfams_pfam_id=array_dumper($data->{protein_properties}->{pfams}->{pfam});				
	$protein_pfams_pfam_id=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$protein_pfams_pfam_id);
	@temp=grep(/pfam_id/,@temp);
	$protein_pfams_pfam_id=join(";",@temp);
	$protein_pfams_pfam_id=~s/; +/;/gi;
	$protein_pfams_pfam_id=~s/pfam_id => ;/pfam_id =>Null/gi;
	$protein_pfams_pfam_id=~s/pfam_id =>//gi;			
		
	my $genbank_protein_id=array_dumper($data->{genbank_protein_id});				
	my $uniprot_id=array_dumper($data->{uniprot_id});				
	my $uniprot_name=array_dumper($data->{uniprot_name});				
	my $pdb_ids=array_dumper($data->{pdb_ids}->{pdb_id});	
	
	my $genbank_gene_id=array_dumper($data->{genbank_gene_id});	
	my $genecard_id=array_dumper($data->{genecard_id});													
	my $geneatlas_id=array_dumper($data->{geneatlas_id});								
	my $hgnc_id=array_dumper($data->{hgnc_id});
	
	my $pubmed_id=array_dumper($data->{general_references}->{reference});
	$pubmed_id=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$pubmed_id);
	@temp=grep(/pubmed_id/,@temp);
	$pubmed_id=join(";",@temp);
	$pubmed_id=~s/; +/;/gi;
	$pubmed_id=~s/  +//gi;
	$pubmed_id=~s/pubmed_id => ;/pubmed_id =>Null/gi;
	$pubmed_id=~s/pubmed_id =>//gi;			

	my $metabolite_references_metabolite_accession=array_dumper($data->{metabolite_references}->{metabolite_reference});		
	$metabolite_references_metabolite_accession=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$metabolite_references_metabolite_accession);
        @temp=grep(/accession/,@temp);
	$metabolite_references_metabolite_accession=join(";",@temp);
	$metabolite_references_metabolite_accession=~s/; +/;/gi;
	$metabolite_references_metabolite_accession=~s/  +//gi;
	$metabolite_references_metabolite_accession=~s/accession => ;/accession =>Null/gi;
	$metabolite_references_metabolite_accession=~s/accession =>//gi;	
	$metabolite_references_metabolite_accession=~s/metabolite =>//gi;	

	my $metabolite_references_pubmed_id=array_dumper($data->{metabolite_references}->{metabolite_reference});		
	$metabolite_references_pubmed_id=~s/[{|}|"|\n]//gi;
	@temp=split(/,/,$metabolite_references_pubmed_id);
        @temp=grep(/pubmed_id/,@temp);
	$metabolite_references_pubmed_id=join(";",@temp);
	$metabolite_references_pubmed_id=~s/; +/;/gi;
	$metabolite_references_pubmed_id=~s/  +//gi;
	$metabolite_references_pubmed_id=~s/pubmed_id => ;/pubmed_id =>Null/gi;
	$metabolite_references_pubmed_id=~s/pubmed_id =>//gi;	
	$metabolite_references_pubmed_id=~s/reference=>//gi;
	 			
	print OUT "$version\t$creation_date\t$update_date\t$accession\t$secondary_accessions\t$protein_type\t$synonyms\t$gene_name\t$general_function\t$specific_function\t$pathways_names\t$pathways_kegg_map_id\t$metabolite_hmdb\t$metabolite_name\t$go_category\t$go_description\t$go_id\t$subcellular_location\t$gene_chromosome_location\t$gene_chromosome_locus\t$protein_residue_number\t$protein_molecular_weight\t$protein_theoretical_pi\t$protein_pfams_pfam_name\t$protein_pfams_pfam_id\t$genbank_protein_id\t$uniprot_id\t$uniprot_name\t$pdb_ids\t$genbank_gene_id\t$genecard_id\t$geneatlas_id\t$hgnc_id\t$pubmed_id\t$metabolite_references_metabolite_accession\t$metabolite_references_pubmed_id\n";
	
}
 
close(OUT);

#THIS HELPS TO THE DESCRIPTION OF THE FILE, IN THIS CASE IS COMMENTED BEACUSE IT WAS ANALYZED BEFORE
