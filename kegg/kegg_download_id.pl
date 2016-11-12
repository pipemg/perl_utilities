#!/usr/bin/perl -w

#@list=`more gene_result.txt |cut -f3|grep -v "GeneID"|sort -n`;
#@list=`more missing.list`;

#mkdir("gene_download");
#chdir("gene_download");


#for($i=0; $i<scalar(@list); $i++){
#	system("wget http://rest.kegg.jp/get/hsa:$list[$i]");
#}


#$limit=150000000; #for a big number 
#for($i=1; $i<$limit; $i++){
#	$result = `if curl --output /dev/null --silent --head --fail http://rest.kegg.jp/get/hsa:$i
#			then
 #   				echo "This URL Exist"
#			else
 #				echo "This URL Not Exist"
#		   fi`;
#	print $result
#	#system("wget http://rest.kegg.jp/get/hsa:".$i);
#}

# cat gene_download/hsa*| grep "EC\:"| perl -pe 's/.+[\[|(]//gi'|perl -pe 's/[\]|)]\n/\n/gi'|perl -pe 's/ /\nec\:/gi'| tr '[:upper:]' '[:lower:]' |grep -v "-"|sort|uniq|grep -v "n" > EC_numbers.list


@list=`more ec_numbers.list`;

mkdir("ec_download");
chdir("ec_download");


for($i=0; $i<scalar(@list); $i++){
	system("wget http://rest.kegg.jp/get/$list[$i]");
}


# cat ec\:*|more| grep "CPD"| perl -pe 's/.+\[//gi'|perl -pe 's/\].{0,1}\n/\n/gi'| tr '[:upper:]' '[:lower:]' | sort|uniq > ../cpd_kegg.list



@list=`more cpd_kegg.list`;

#mkdir("cpd_download");
#chdir("cpd_download");


#for($i=0; $i<scalar(@list); $i++){
#	system("wget http://rest.kegg.jp/get/$list[$i]");
#}


#cat * |grep "RN\:"|perl -pe 's/.+\[RN\:/RN\:/gi'|grep "\]"|perl -pe 's/\].{0,1}//gi'|perl -pe 's/ R/\nRN\:R/gi' |tr '[:upper:]' '[:lower:]' | sort|uniq > rx_kegg.list



@list=`more rx_kegg.list`;

#mkdir("rxn_download");
#chdir("rxn_download");


#for($i=0; $i<scalar(@list); $i++){
#	system("wget http://rest.kegg.jp/get/$list[$i]");
#}

