#!/usr/bin/perl -w
use strict;

my  @files=`ls bigg`;



my ($title, $u_metabolite, $name, $formula, $model, $met_model_name, $old_id, $hmdb_id, $metanetx_id, $chebi_id, $lipidmaps_id, $biocyc, $kegg, $reactome, $seed, $umbbd, $unipathway, $reactome_id, $line);


open(OUT,">bigg_recon1_metabolites.tsv") || die "INPUT FILE bigg_recon1_metabolites.tsv WAS NOT CREATED";

chdir("bigg");

print OUT ("#title\tu_metabolite\tname\tformula\tmodel\tmet_model_name\told_id\thmdb_id\tmetanetx_id\tchebi_id\tlipidmaps_id\tbiocyc\tkegg\treactome\tseed\tumbbd\tunipathway\treactome_id\n");


for (my $i=0;$i<scalar(@files);$i++){
   chomp($files[$i]);
   open(IN,$files[$i])||die "INPUT FILE $files[$i] WAS NOT CREATED";


   $title="";
   $u_metabolite="";
   $name="";
   $formula="";
   $model="";
   $met_model_name="";
   $old_id="";
   $hmdb_id="";
   $metanetx_id="";
   $chebi_id="";
   $lipidmaps_id="";
   $biocyc="";
   $kegg="";
   $reactome="";
   $seed="";
   $umbbd="";
   $unipathway="";
   $reactome_id="";
   $line="";


   while($line=<IN>){
	
	chomp($line);
	
	
	if($line=~/<title>BiGG Metabolite/){
		$line=~s/ +<title>BiGG Metabolite: //gi;
		$line=~s/<\/title>//gi;
		$title.=$line;
	}
	if($line=~/Universal metabolite/){
		$line=<IN>;
		chomp($line);
		$line=~s/ +<span>//gi;
		$line=~s/<\/span>//gi;
		$u_metabolite.=$line;
	}

	if($line=~/Descriptive name/){
		$line=<IN>;
		chomp($line);
		$line=~s/ +<p>//gi;
		$line=~s/<\/p>//gi;
		$name.=$line;
	}

	if($line=~/Formulae in BiGG/){
		$line=<IN>;
		chomp($line);
		$line=~s/ +<p>//gi;
		$line=~s/<\/p>//gi;
		$formula=$line;
	}


	if($line=~/RECON1/){
		$line=~s/  +<td>//gi;
		$line=~s/<\/td>//gi;
		$model=$line;
		$line=<IN>;
		chomp($line);
		$line=~s/ +<td>//gi;
		$line=~s/<\/td>//gi;
		$met_model_name=$line;
	}


	if($line=~/Old identifiers/){
		$line=<IN>;
		$line=<IN>;
		chomp($line);
		$line=~s/ +//gi;
		$old_id.=";".$line;
	}

	if($line=~/identifiers.org\/biocyc/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$biocyc.=";".$line;
	}

	if($line=~/identifiers.org\/kegg.compound/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$kegg.=";".$line;
	}

	if($line=~/identifiers.org\/hmdb/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$hmdb_id.=";".$line;
	}

	if($line=~/identifiers.org\/chemical/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$metanetx_id.=";".$line;
	}



	if($line=~/identifiers.org\/chebi/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$chebi_id.=";".$line;
	}

	if($line=~/identifiers\.org\/lipidmaps/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$lipidmaps_id.=";".$line;
	}

	if($line=~/identifiers\.org\/reactome/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$reactome_id.=";".$line;
	}

	if($line=~/identifiers\.org\/seed.compound/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$seed.=";".$line;
	}

	if($line=~/identifiers\.org\/umbbd.compound/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$umbbd.=";".$line;
	}

	if($line=~/identifiers\.org\/unipathway.compound/){
		$line=~s/.+target="_blank">//gi;
		$line=~s/<\/a>//gi;
		$unipathway.=";".$line;
	}

   }
	$line="$title\t$u_metabolite\t$name\t$formula\t$model\t$met_model_name\t$old_id\t$hmdb_id\t$metanetx_id\t$chebi_id\t$lipidmaps_id\t$biocyc\t$kegg\t$reactome\t$seed\t$umbbd\t$unipathway\t$reactome_id\n";
	$line=~s/\n\t/\t/gi;
	$line=~s/,;/;/gi;
	$line=~s/\t {0,1};/\t/gi;
	print OUT ($line);

   close(IN);

}

