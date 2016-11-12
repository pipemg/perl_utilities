#!/usr/bin/perl -w

use strict;
use IO::File;


my $file = "bigg_metabolites.tsv";

open(IN,$file)||die "Input file couldn't be open";

my $reference_column=1;
my $number_columns=11;
my $primary_sep="\t";
my $secondary_sep=";";
my @fh=();
my @sep_line=();
my $temp="";
my @header=();

while(my $line=<IN>){
	chomp($line);
	
	#if is header
	if($line=~m/^#/){
	   $line=~s/#//gi;
	   @sep_line=split($primary_sep,$line);
	   @header=@sep_line;

	   for(my $i=1; $i<scalar(@sep_line); $i++){
	      $fh[$i]=IO::File->new();
	      print "Open: ".$sep_line[$i]."\t".$fh[$i]."\n";
	      open($fh[$i],">table_$sep_line[$i].tsv")||die "Error in creation file $sep_line[$i] error";
	   }
	}else{
	   my @sep_line=split($primary_sep,$line);
	   for(my $i=1; $i<scalar(@sep_line); $i++){
	       $sep_line[$i]=~s/;/\n$sep_line[0]\t/gi;
	       $temp=$fh[$i];
	       print $temp ($sep_line[0]."\t".$sep_line[$i]."\n");     
	   }
	}
}

close(IN);
print "Input file closed";

for(my $i=1; $i<scalar(@sep_line); $i++){
   print "Closing:\t $fh[$i]\n";
   $temp=$fh[$i];
   close($temp);
}

print "Line reports\nlines\twords\tcharacters\tnames\n";
for(my $i=1;$i<scalar(@header);$i++){
	print `wc table_$header[$i].tsv`;
}

