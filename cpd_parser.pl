#!/usr/bin/perl -w


open(OUT, ">cpd_output.tsv")||die "Output File couldn't be created";

print OUT ("#ENTRY\tENTRY_Type\tNAMES\tFORMULA\tEXACT_MASS\tMOL_WEIGHT\tREMARK\t3DMET\tCAS\tChEBI\tKNApSAcK\tLipidBank\tLIPIDMAPS\tNIKKAJI\tPDB-CCD\tPubChem\tCOMMENT\n");


chdir("cpd_download");

@files=`ls cpd_*`;

# BASH:
# cat cpd_download/*|grep -P "^[A-Z]+ +"|perl -pe 's/  +.+//gi'|sort|uniq 

#CLASS COMMENT DBLINKS ENTRY GENES HISTORY NAME ORTHOLOGY PATHWAY PRODUCT REACTION REFERENCE SUBSTRATE SYSNAME



for($i=0; $i<scalar(@files); $i++){
   open(IN, $files[$i])|| die ("no se pudo abrir el archivo ".$files[$i]);

  
   
   @tmp=();

   $ENTRY="Null";
   $ENTRY_Type="Null";
   $NAMES="Null";
   $FORMULA="Null";
   $EXACT_MASS="Null";
   $MOL_WEIGHT="Null";
   $REMARK="Null";
   $_3DMET="Null";
   $_CAS="Null";
   $_ChEBI="Null";
   $_KNApSAcK="Null";
   $_LipidBank="Null";
   $_LIPIDMAPS="Null";
   $_NIKKAJI="Null";
   $_PDB_CCD="Null";
   $_PubChem="Null";
   $COMMENT="Null";

   #ENZYME;




   while($line=<IN>){
      chomp($line);

      if($line=~/^ENTRY /){
         @tmp=split(/ {3,100}/,$line);
         $ENTRY=$tmp[1];
	 $ENTRY_Type=$tmp[2];

      }

      if($line=~/^NAME +/){
         $line=~s/^NAME +//gi;
         $NAMES=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $NAMES.=$line;
	 }
      }

       if($line=~/^FORMULA +/){
         $line=~s/^FORMULA +//gi;
         $FORMULA=$line;
      }

       if($line=~/^EXACT_MASS +/){
         $line=~s/^EXACT_MASS +//gi;
         $EXACT_MASS=$line;
      }


     
      if($line=~/^MOL_WEIGHT +/){
         $line=~s/^MOL_WEIGHT +//gi;
         $MOL_WEIGHT=$line;
      }

      if($line=~/^REMARK +/){
         $line=~s/^REMARK +//gi;
         $REMARK=$line;
      }

      if($line=~/[A-Z ]+3DMET\: /){
         $line=~s/[A-Z ]+3DMET\: /3DMET\:/gi;
         $_3DMET=$line;
      }

      if($line=~/[A-Z ]+CAS\: /){
         $line=~s/[A-Z ]+CAS\: /CAS\:/gi;
         $_CAS=$line;
      }

      if($line=~/[A-Z ]+ChEBI\: /){
         $line=~s/[A-Z ]+ChEBI\: /ChEBI\:/gi;
         $_ChEBI=$line;
      }

      if($line=~/[A-Z ]+KNApSAcK\: /){
         $line=~s/[A-Z ]+KNApSAcK\: /KNApSAcK\:/gi;
         $_KNApSAcK=$line;
      }

      if($line=~/[A-Z ]+LipidBank\: /){
         $line=~s/[A-Z ]+LipidBank\: /LipidBank\:/gi;
         $_LipidBank=$line;
      }


      if($line=~/[A-Z ]+LIPIDMAPS\: /){
         $line=~s/[A-Z ]+LIPIDMAPS\: /LIPIDMAPS\:/gi;
         $_LIPIDMAPS=$line;
      }

      if($line=~/[A-Z ]+NIKKAJI\: /){
         $line=~s/[A-Z ]+NIKKAJI\: /NIKKAJI\:/gi;
         $_NIKKAJI=$line;
      }

      if($line=~/[A-Z ]+PDB-CCD\: /){
         $line=~s/[A-Z ]+PDB-CCD\: /PDB-CCD\:/gi;
         $_PDB_CCD=$line;
      }

      if($line=~/[A-Z ]+PubChem\: /){
         $line=~s/[A-Z ]+PubChem\: /PubChem\:/gi;
         $_PubChem=$line;
      }




  
       if($line=~/^COMMENT +/){
         $line=~s/^COMMENT +//gi;
         $COMMENT=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $COMMENT.=$line;
	 }
      }


   }


  print OUT ("$ENTRY\t$ENTRY_Type\t$NAMES\t$FORMULA\t$EXACT_MASS\t$MOL_WEIGHT\t$REMARK\t$_3DMET\t$_CAS\t$_ChEBI\t$_KNApSAcK\t$_LipidBank\t$_LIPIDMAPS\t$_NIKKAJI\t$_PDB_CCD\t$_PubChem\t$COMMENT\n");



}

close(OUT);
