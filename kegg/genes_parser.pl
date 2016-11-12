#!/usr/bin/perl -w


open(OUT, ">genes_output.tsv")||die "Output File couldn't be created";

chdir("gene_download/");

@files=`ls hsa_*`;


#@keys = ("AASEQ", "BRITE", "DBLINKS", "DEFINITION", "DISEASE", "ENTRY", "MODULE", "MOTIF", "NAME", "NTSEQ", "ORGANISM", "ORTHOLOGY", "PATHWAY", "POSITION", "STRUCTURE", "DRUG_TARGET");

   print  OUT ("#ENTRY\tENTRY_Type\tNAMES\tDEFINITION\tORGANISM\tPOSITION\tEnsembl\tHGNC\tHPRD\tmiRBase\tNCBIG\tNCBIP\tOMIM\tUniProt\tVega\n");

for($i=0; $i<scalar(@files); $i++){
   open(IN, $files[$i])|| die ("no se pudo abrir el archivo ".$files[$i]);


   
   @tmp=();

   $ENTRY="Null";
   $NAMES="Null";
   $DEFINITION="Null";           
   $ORGANISM="Null";     
   $POSITION="Null";

   $Ensembl="Null";
   $HGNC="Null";
   $HPRD="Null";
  # $IMGT="Null";
   $miRBase="Null";
   $NCBIG="Null";
   $NCBIP="Null";
   $OMIM="Null";
   $UniProt="Null";
   $Vega="Null";

   while($line=<IN>){
      chomp($line);

      if($line=~/ENTRY +/){
         @tmp=split(/ {1,100}/,$line);
         $ENTRY=$tmp[1];
	 $ENTRY_Type=$tmp[2];
	 if(!($ENTRY=~/[0-9]+/)){
	   print ("Entry Error.. File ".$files[$i]);
           print($tmp[1]);
	   exit(0);
	 }

      }

      if($line=~/NAME +/){
         $line=~s/NAME +//gi;
         $NAMES=$line;

      }

      if($line=~/DEFINITION +/){
         $line=~s/DEFINITION +//gi;
         $line=~s/\(RefSeq\) +//gi;
         $DEFINITION=$line;         

      }

      if($line=~/ORGANISM +/){
         $line=~s/ORGANISM +//gi;
	 $line=~s/\|//gi;
	 $ORGANISM=$line;  

      }

      if($line=~/POSITION +/){
         $line=~s/POSITION +//gi;
	 $line=~s/\|//gi;
         $POSITION=$line;

      }


      if($line=~/Ensembl\:/){
         $Ensembl=$line;
         $Ensembl=~s/[A-Z ]+Ensembl\: /Ensembl\:/gi;
      }
      if($line=~/HGNC\:/){
        $HGNC=$line;
	$HGNC=~s/[A-Z ]+HGNC\: /HGNC\:/gi;
      }
      if($line=~/HPRD\:/){
	$HPRD=$line;
	$HPRD=~s/[A-Z ]+HPRD\: /HPRD\:/gi;
      }

      if($line=~/miRBase\:/){
	$miRBase=$line;
	$miRBase=~s/[A-Z ]+miRBase\: /miRBase\:/gi;
      }
      if($line=~/NCBI-GeneID\:/){
	$NCBIG=$line;
	$NCBIG=~s/[A-Z ]+NCBI-GeneID\: /NCBI-GeneID\:/gi;
      }
      if($line=~/NCBI-ProteinID\:/){
	$NCBIP=$line;
	$NCBIP=~s/[A-Z ]+NCBI-ProteinID\: /NCBI-ProteinID\:/gi;
      }
      if($line=~/OMIM\:/){
	$OMIM=$line;
	$OMIM=~s/[A-Z ]+OMIM\: /OMIM\:/gi;
      }
      if($line=~/UniProt\:/){
	$UniProt=$line;
	$UniProt=~s/[A-Z ]+UniProt\: /UniProt\:/gi;
      }
      if($line=~/Vega\:/){
	$Vega=$line;
	$Vega=~s/[A-Z ]+Vega\: /Vega\:/gi;
      }

   }
  print  OUT ($ENTRY."\t".$ENTRY_Type."\t".$NAMES."\t".$DEFINITION."\t".$ORGANISM."\t".$POSITION."\t".$Ensembl."\t".$HGNC."\t".$HPRD."\t".$miRBase."\t".$NCBIG."\t".$NCBIP."\t".$OMIM."\t".$UniProt."\t".$Vega."\n");

}

close(OUT);
