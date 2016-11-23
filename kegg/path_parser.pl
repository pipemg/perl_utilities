#!/usr/bin/perl -w


open(OUT, ">path_output.tsv")||die "Output File couldn't be created";
print  OUT ("#ENTRY\tENTRY_type\tNAME\tDEFINITION\tENZIME\tEQUATION\tRPAIR\n");

chdir("paths_download/");

@files=`ls hsa*`;

# COMMENT  DEFINITION  ENTRY  ENZYME  EQUATION  MODULE  NAME  ORTHOLOGY  PATHWAY  REMARK  RPAIR
# cat rx_download/* |cut -d " " -f1|sort|uniq

for($i=0; $i<scalar(@files); $i++){
   open(IN, $files[$i])|| die ("no se pudo abrir el archivo ".$files[$i]);
   
   @tmp=();
 
   $flag=0;


   $ENTRY="Null";
   $ENTRY_type="Null";
   $NAME="Null";
   $DESCRIPTION="Null";
   $CLASSIFICATION="Null";
   $CLASS="Null";
   $PATHWAY_MAP="Null";	
   $PATHWAY_NAME="Null";	
   #$MODULE="Null";
 #  $DISEASE="Null";
 #  $DRUG="Null";
 #  $ORGANISM="Null";
   $GENE_entrez="Null";
   $GENE_symbol="Null";
   $GENE_name="Null";
 #  $GENE_ko="Null";
 #  $GENE_ec="Null";
 #  $COMPOUND ="Null";
  # $KO_PATHWAY="Null";  

   while($line=<IN>){
      chomp($line);

      if($flag==1){
	if($line=~/^ {3,}/){
	 $line=~s/^ {3,}//;
         @tmp=split(/  /,$line);
         @tmp2=split(/;|\[/,$tmp[1]);
         $GENE_entrez=$GENE_entrez.",".$tmp[0];
    	 $GENE_symbol=$GENE_symbol.",".$tmp2[0];
	# $GENE_name=$GENE_name.",".$tmp2[1];
	 $flag=1;	
	}else{
	 $flag=0;
	}
      }

      if($line=~/^ENTRY /){
         @tmp=split(/ {3,100}/,$line);
         $ENTRY=$tmp[1];
	 $ENTRY_type=$tmp[2];

      }

      if($line=~/^NAME /){
         $line=~s/^NAME +//;
         $line=~s/ \- Homo sapiens \(human\)//;
         $NAME=$line;
      }
      
     if($line=~/DESCRIPTION /){
	 $DESCRIPTION=~s/^DESCRIPTION {1,}//;
     }
     
     if($line=~/CLASS/){
       	$CLASSIFICATION="";
   	$CLASS="";
   	$line=~s/^CLASS +//;
        @tmp=split(/; /,$line);
   	$CLASSIFICATION=$tmp[0];
   	if(scalar(@tmp)>0){
	  	$CLASS=$tmp[1];
	  }
     }

      if($line=~/PATHWAY_MAP/){
         $line=~s/^PATHWAY_MAP +//;
         @tmp=split(/  /, $line);
         $PATHWAY_MAP=$tmp[0];
         $PATHWAY_NAME=$tmp[1];
     }
     
     
      if($line=~/GENE/){
         $line=~s/^GENE +//;
         @tmp=split(/  /,$line);
         @tmp2=split(/;|\[/,$tmp[1]);
       #  print(."\t".."\t".."\n");
         $GENE_entrez=$tmp[0];
    	 $GENE_symbol=$tmp2[0];
	 #$GENE_name=$tmp2[1];
	 $flag=1;
     }


   }
   print OUT  ("$ENTRY\t$NAME\t$CLASSIFICATION\t$CLASS\t$PATHWAY_MAP\t$PATHWAY_NAME\t$GENE_entrez\t$GENE_symbol\t$GENE_name\n");

}

close(OUT);
