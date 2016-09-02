#!/usr/bin/perl -w


open(OUT, ">rx_output.tsv")||die "Output File couldn't be created";
print  OUT ("#ENTRY\tENTRY_type\tNAME\tDEFINITION\tENZIME\tEQUATION\tRPAIR\n");

chdir("rx_download/");

@files=`ls rn_r*`;

# COMMENT  DEFINITION  ENTRY  ENZYME  EQUATION  MODULE  NAME  ORTHOLOGY  PATHWAY  REMARK  RPAIR
# cat rx_download/* |cut -d " " -f1|sort|uniq

for($i=0; $i<scalar(@files); $i++){
   open(IN, $files[$i])|| die ("no se pudo abrir el archivo ".$files[$i]);
   
   @tmp=();

   $ENTRY="Null";
   $ENTRY_type="Null";
   $NAME="Null";
   $DEFINITION="Null";
   $EQUATION="Null";
   $RPAIR="Null";  
   $ENZYME="Null";  

   while($line=<IN>){
      chomp($line);

      if($line=~/^ENTRY /){
         @tmp=split(/ {3,100}/,$line);
         $ENTRY=$tmp[1];
	 $ENTRY_type=$tmp[2];

      }

      if($line=~/^NAME /){
         $line=~s/^NAME +//;
         $NAME=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $NAME.=$line;
	 }
      }
      
     if($line=~/DEFINITION/){
	
	 $line=~s/^DEFINITION {1,}//;
         $DEFINITION=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $DEFINITION.=$line;
	 }

     }


     if($line=~/ENZYME/){
	 $line=~s/^ENZYME {1,}//;
	 $line=~s/ +/ /;
         $ENZYME=$line;
     }

     if($line=~/EQUATION/){
	 $line=~s/^EQUATION {1,}//;
         $EQUATION=$line;
     }


     if($line=~/RPAIR/){
	 $line=~s/^RPAIR {1,}//;
         $RPAIR=$line;
	 while($line=~/;/){
	    $line=<IN>;
     	    chomp($line);
	    $line=~s/^ +//gi;
	    $RPAIR.=$line;
	 }
     }

   }
   print  OUT ("$ENTRY\t$ENTRY_type\t$NAME\t$DEFINITION\t$ENZYME\t$EQUATION\t$RPAIR\n");

}

close(OUT);
