#!/usr/bin/perl -w


open(OUT, ">ec_output.tsv")||die "Output File couldn't be created";

print  OUT ("#ENTRY\tENTRY_Type\tNAMES\tCLASS\tSYSNAME\tREACTION\tREACTIONRN\tALL_REAC\tSUBSTRATES_names\tSUBSTRATES\tPRODUCTS_names\tPRODUCTS\tCOMMENT\tHSA_GENES\n");


chdir("ec_download");

@files=`ls ec*`;

# BASH:
# cat ec_download/*|grep -P "^[A-Z]+ +"|perl -pe 's/  +.+//gi'|sort|uniq 

#CLASS COMMENT DBLINKS ENTRY GENES HISTORY NAME ORTHOLOGY PATHWAY PRODUCT REACTION REFERENCE SUBSTRATE SYSNAME




for($i=0; $i<scalar(@files); $i++){
   open(IN, $files[$i])|| die ("no se pudo abrir el archivo ".$files[$i]);

   
   @tmp=();

   $ENTRY="Null";
   $ENTRY_Type="Null";
   $NAMES="Null";
   $CLASS="Null";
   $SYSNAMES="Null";
   $REACTION="Null";  
   $REACTIONRN="Null";   
   $ALL_REAC="Null";                                     
   $SUBSTRATES_names="Null";    
   $SUBSTRATES="Null"; 
   $PRODUCTS_names="Null";     
   $PRODUCTS="Null";
   $COMMENT="Null";
   $HSA_GENES="Null";

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

       if($line=~/^CLASS +/){
         $line=~s/^CLASS +//gi;
         $CLASS=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $CLASS.=$line;
	 }

      }

       if($line=~/^SYSNAME +/){
         $line=~s/^SYSNAME +//gi;
         $SYSNAMES=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $SYSNAMES.=$line;
	 }

      }
     

       if($line=~/^REACTION +/){
         $line=~s/^REACTION +//gi;
	 @tmp=split(/\[RN/,$line);
         $REACTION=$tmp[0];
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $REACTION.=$line;
	 }
	@RXS=split(/ /,$line);
	$REACTION=~s/\[RN.+\]//g;

	for($j=0;$j<scalar(@RXS);$j++){
		chomp($RXS[$j]);
		if($RXS[$j]=~/\[RN/){
			if($REACTIONRN eq "Null"){
				$REACTIONRN = $RXS[$j];
			}else{
				$REACTIONRN.=";".$RXS[$j];
			}
		}
	}

      }


       if($line=~/^ALL_REAC +/){
         $line=~s/^ALL_REAC +//gi;
         $ALL_REAC=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $ALL_REAC.=$line;
	 }

      }


       if($line=~/^SUBSTRATE +/){
         $line=~s/^SUBSTRATE +//gi;
         $SUBSTRATES_names=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $SUBSTRATES_names.=$line;
	 }

	@tmp=split(/\[/,$SUBSTRATES_names);
	$SUBSTRATES_names=~s/ {0,}\[[CPD\:[0-9]+\]//gi;
	for($j=0;$j<scalar(@tmp);$j++){
		if($tmp[$j]=~/^CPD\:/){
			$tmp[$j]=~s/\].{0,}//gi;
			if($SUBSTRATES eq "Null"){
			    $SUBSTRATES=$tmp[$j];
			}else{
			    $SUBSTRATES.=";".$tmp[$j];
			}			
		}
	}

      }
     

       if($line=~/^PRODUCT +/){
         $line=~s/^PRODUCT +//gi;
         $PRODUCTS_names=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $PRODUCTS_names.=$line;
	 }

	 @tmp=split(/\[/,$PRODUCTS_names);
	 $PRODUCTS_names=~s/ {0,}\[[CPD\:[0-9]+\]//gi;
	 for($j=0;$j<scalar(@tmp);$j++){
		if($tmp[$j]=~/^CPD\:/){
			$tmp[$j]=~s/\].{0,}//gi;
			if($PRODUCTS eq "Null"){
			    $PRODUCTS=$tmp[$j];
			}else{
			    $PRODUCTS.=";".$tmp[$j];
			}			
		}
	 } 

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

       if($line=~/HSA\: +/){
         $line=~s/GENES +//gi;
         $line=~s/HSA\: +//gi;
         $HSA_GENES=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $HSA_GENES.=$line;
	 }

      }
     


   }


    print OUT ("$ENTRY\t$ENTRY_Type\t$NAMES\t$CLASS\t$SYSNAMES\t$REACTION\t$REACTIONRN\t$ALL_REAC\t$SUBSTRATES_names\t$SUBSTRATES\t$PRODUCTS_names\t$PRODUCTS\t$COMMENT\t$HSA_GENES\n");


}

close(OUT);
