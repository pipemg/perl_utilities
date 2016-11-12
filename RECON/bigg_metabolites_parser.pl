#!/usr/bin/perl -w
use strict;
use Switch;


my $file="in_bigg_metabolites.tsv";



my $line="";
my @arrayline=();
my $val="";
my %matrix_hash=();
my $bigg_id="";
my ($key,$value);

open(IN, $file)|| die ("IN file error ");

while($line=<IN>){
   chomp($line);
   @arrayline=split(/\t/,$line);
      
   for(my $i=0;$i<scalar(@arrayline);$i++){
      $val=$arrayline[$i];
      switch ($val){
         case /BiGG\ Metabolite/	
         	{
         	$val=~s/BiGG Metabolite\: // ;
         	$matrix_hash{$val}{"bigg_symbol"}=$val;
         	$bigg_id=$val;
        	next;

         	} 
         	
         case /biocyc/ 
         	{
         	$val=~s/biocyc\///;  
         	$matrix_hash{$bigg_id}{"biocyc"} = defined $matrix_hash{$bigg_id}{"biocyc"} ? $matrix_hash{$bigg_id}{"biocyc"}.";".$val : $val;
         	next;
         	} 

         case /hmdb/ 
         	{
         	$val=~s/hmdb\///;  
         	$matrix_hash{$bigg_id}{"hmdb"} = defined $matrix_hash{$bigg_id}{"hmdb"} ? $matrix_hash{$bigg_id}{"hmdb"}.";".$val : $val;
         	next;
         	} 
         	
         	
        
         case /chebi/ 
         	{
         	$val=~s/chebi\///;  
         	$matrix_hash{$bigg_id}{"chebi"} = defined $matrix_hash{$bigg_id}{"chebi"} ? $matrix_hash{$bigg_id}{"chebi"}.";".$val : $val;
         	next;
         	} 
         	
                
         case /kegg.compound/ 
         	{
         	$val=~s/kegg.compound\///;  
         	$matrix_hash{$bigg_id}{"kegg.compound"} = defined $matrix_hash{$bigg_id}{"kegg.compound"} ? $matrix_hash{$bigg_id}{"kegg.compound"}.";".$val : $val;
         	next;
         	} 

         case /lipidmaps/ 
         	{
         	$val=~s/lipidmaps\///;  
         	$matrix_hash{$bigg_id}{"lipidmaps"} = defined $matrix_hash{$bigg_id}{"lipidmaps"} ? $matrix_hash{$bigg_id}{"lipidmaps"}.";".$val : $val;
         	next;
         	}         	 	

         case /metanetx.chemical/ 
         	{
         	$val=~s/metanetx.chemical\///;  
         	$matrix_hash{$bigg_id}{"metanetx.chemical"} = defined $matrix_hash{$bigg_id}{"metanetx.chemical"} ? $matrix_hash{$bigg_id}{"metanetx.chemical"}.";".$val : $val;
         	next;
         	}            	         

         case /reactome/ 
         	{
         	$val=~s/reactome\///;  
         	$matrix_hash{$bigg_id}{"reactome"} = defined $matrix_hash{$bigg_id}{"reactome"} ? $matrix_hash{$bigg_id}{"reactome"}.";".$val : $val;
         	next;
         	}         	 	

         case /seed.compound/ 
         	{
         	$val=~s/seed.compound\///;  
         	$matrix_hash{$bigg_id}{"seed.compound"} = defined $matrix_hash{$bigg_id}{"seed.compound"} ? $matrix_hash{$bigg_id}{"seed.compound"}.";".$val : $val;
         	next;
         	}         	 	

         case /umbbd.compound/ 
         	{
         	$val=~s/umbbd.compound\///;  
         	$matrix_hash{$bigg_id}{"umbbd.compound"} = defined $matrix_hash{$bigg_id}{"umbbd.compound"} ? $matrix_hash{$bigg_id}{"umbbd.compound"}.";".$val : $val;
         	next;
         	}   

         case /unipathway.compound/ 
         	{
         	$val=~s/unipathway.compound\///;  
         	$matrix_hash{$bigg_id}{"unipathway.compound"} = defined $matrix_hash{$bigg_id}{"unipathway.compound"} ? $matrix_hash{$bigg_id}{"unipathway.compound"}.";".$val : $val;
         	next;
         	}   

      }
   }
}   

close(IN);



while ( ($key,$value) = each (%matrix_hash )) {

	if(not defined ($matrix_hash{$key}{"biocyc"}) ){
		$matrix_hash{$key}{"biocyc"}="NULL";}
		
	if(not defined($matrix_hash{$key}{"hmdb"})){
		$matrix_hash{$key}{"hmdb"}="NULL";}
		
	if(not defined($matrix_hash{$key}{"chebi"})){
		$matrix_hash{$key}{"chebi"}="NULL";}
		
	if(not defined($matrix_hash{$key}{"kegg.compound"})){
		$matrix_hash{$key}{"kegg.compound"}="NULL";}		

	if(not defined($matrix_hash{$key}{"lipidmaps"})){
		$matrix_hash{$key}{"lipidmaps"}="NULL";}
		
	if(not defined($matrix_hash{$key}{"metanetx.chemical"})){
		$matrix_hash{$key}{"metanetx.chemical"}="NULL";}
		
	if(not defined($matrix_hash{$key}{"reactome"})){
		$matrix_hash{$key}{"reactome"}="NULL";}
		
	if(not defined($matrix_hash{$key}{"seed.compound"})){
		$matrix_hash{$key}{"seed.compound"}="NULL";}				
		
	if(not defined($matrix_hash{$key}{"umbbd.compound"})){
		$matrix_hash{$key}{"umbbd.compound"}="NULL";}
		
	if(not defined($matrix_hash{$key}{"unipathway.compound"})){
		$matrix_hash{$key}{"unipathway.compound"}="NULL";}			
}


open(OUT, ">bigg_metabolites.tsv")|| die "bigg metabolites output file wasn't created";

print OUT "#bigg_symbol\tbiocyc\thmdb\tchebi\tkegg.compound\tlipidmaps\tmetanetx.chemical\treactome\tseed.compound\tumbbd.compound\tunipathway.compound\n";	
    
while ( ($key, $value) = each %matrix_hash ) {
    print OUT $matrix_hash{$key}{"bigg_symbol"}."\t".$matrix_hash{$key}{"biocyc"}."\t".$matrix_hash{$key}{"hmdb"}."\t".$matrix_hash{$key}{"chebi"}."\t".$matrix_hash{$key}{"kegg.compound"}."\t".$matrix_hash{$key}{"lipidmaps"}."\t".$matrix_hash{$key}{"metanetx.chemical"}."\t".$matrix_hash{$key}{"reactome"}."\t".$matrix_hash{$key}{"seed.compound"}."\t".$matrix_hash{$key}{"umbbd.compound"}."\t".$matrix_hash{$key}{"unipathway.compound"}."\n";	
}

close(OUT);
