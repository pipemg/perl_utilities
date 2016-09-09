#!/usr/bin/perl -w
use strict;

use Getopt::Long;
my %opts = ();
GetOptions (\%opts,
	    'm=s',
	    'r=s',
	    'f=s',
	    'h|help');
if(scalar(keys(%opts)) == 0){
  print "usage:	Descargar recon 2 desde la pagina web pdf\n";
  print "-m archivo con la lista de metabolitos. La primera columna debe ser la abreviaci\'on que usa recon. \n";
  print "-r archivo con la lista de reacciones. La primera columna debe ser la abreviaci\'on que usa recon. \n";
  print "-f output folder\n";
  print "-h | -help	Help\n";
  exit;
}

if($opts{'h'}){
  &PrintHelp;
}


print "Este programa se encarga de descargar la base de datos de recon 2 desde su pagina web http://humanmetabolism.org/?page_id=7 y http://humanmetabolism.org/?page_id=5\n";

if($opts{'f'}){
	if(!exists($opts{'f'})){
		mkdir($opts{'f'});
	}
	chdir($opts{'f'});
}





if($opts{'m'}){


open(MOUT,">metabolits.tb") || die "metabolits output file can't be open";

print MOUT ("#Abbreviation\tDescription\tNeutralFormula\tChargedFormula\tCharge\tKeggID\tPubChemID\tCheBlID\tInchiString\tSmile\tHMDB\tLastModified\n");

	open(META,$opts{'m'}) || die "metabolits file can't be open";
	my $line="";
	my $read="";
	my $id="";
	my $html="";
	my %hashmap;
	while($read=<META>){
		chomp($read);
		$id=(split(/\t/,$read))[0];
		my $idc=$id;
		$id=~s/\(/\\\(/;
		$id=~s/\)/\\\)/;
		$line="wget \"http://humanmetabolism.org/?page_id=7&Abbreviation=$id\"  --output-document=$id\.html\n";
		print $line;
		system($line);
		open(TEMPORAL,"$idc.html") || die "html $id can't be read";
			while($html=<TEMPORAL>){
				if($html=~/rTextWrap/){
					$html=~s/<\/br><span class\='columnName'>/\n/gi; 
					$html=~s/.+class\='columnName'>/\n/gi; 
					$html=~s/\:<\/span> +/\t/gi;
					$html=~s/<a href.+'>//g;
					$html=~s/<\/a>//gi;
					$html=~s/<\/br>.+//gi;
					$html=~s/.+\t//gi;
					$html=~s/\n/\t/gi;
					print MOUT ("$html\n");
				}
			}
		close(TEMPORAL);
		system("rm $id\.html");
	}
	close(META);
close(MOUT);
}



if($opts{'r'}){


open(ROUT,">reactions.tb") || die "reactions output file can't be open";

print ROUT ("#Abbreviation\tDescription\tFormula\tReversible\tMCS\tNotes\tRef\tECNumber\tKeggID\tLastModified\tLB\tUB\tCS\tGPR\tSubsystem\n");

	open(REAX,$opts{'r'}) || die "reactions file can't be open";
	my $line="";
	my $read="";
	my $id="";
	my $html="";
	my %hashmap;
	while($read=<REAX>){
		chomp($read);
		$id=(split(/\t/,$read))[0];
		my $idc=$id;
		$id=~s/\(/\\\(/;
		$id=~s/\)/\\\)/;
		$line="wget \"http://humanmetabolism.org/?page_id=5&Abbreviation=$id\"  --output-document=$id\.html\n";
		system($line);
		open(TEMPORAL,"$idc.html") || die "html $idc can't be read";
			while($html=<TEMPORAL>){
				if($html=~/rTextWrap/){
					$html=~s/<\/br><span class\='columnName'>/\n/gi; 
					$html=~s/.+class\='columnName'>/\n/gi; 
					$html=~s/\:<\/span> +/\t/gi;
					$html=~s/<a href='[\?a-z0-9_=&A-Z]+'>//g;
					$html=~s/<\/a>//gi;
					$html=~s/<a href.+'>//g;
					$html=~s/<\/br>.+//gi;
					$html=~s/.+\t//gi;
					$html=~s/\n/\t/gi;
					print ROUT ("$html\n");
				}
			}
		close(TEMPORAL);
		system("rm $id\.html");
	}
	close(REAX);
close(ROUT);
}

