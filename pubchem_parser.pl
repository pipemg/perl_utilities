#!/usr/local/bin/perl -w
use strict;

my @pubchem_files=`ls SDF/*sdf`;

=head1 PUBCHEM_COMPOUND_CID

PubChem Compound ID (CID) is the non-zero unsigned integer PubChem 
accession ID for a unique chemical structure. For example, "4231". 

=head1 PUBCHEM_COMPOUND_CANONICALIZED

Boolean flag, indicated by a one or a zero, denoting whether the
compound was subjected to valence-bond canonicalization procedure.
Not all valid compounds can be subjected to this procedure. For
example, "1". 

=head1  PUBCHEM_CACTVS_COMPLEXITY

Complexity measure, a floating point number, calculated for a
Compound where less complex and more symmetrical molecules have
smaller values and more complex and less symmetrical molecules have
larger values, using the Xemistry GmbH's Cactvs implementation.
For example, "921.222".

=head1  PUBCHEM_CACTVS_SUBSKEYS

Substructure Fingerprint calculated for a Compound using the
Xemistry GmbH's Cactvs implementation. This is base64 encoded
binary data where the first four binary bytes give the length of
the fingerprint bit list. The description of the individual bits
is provided elsewhere. To learn more about the PubChem
substructure fingerprint, go to "ftp://ftp.ncbi.nlm.nih.gov/
pubchem/specifications/pubchem_fingerprint.txt". 

=head1 PUBCHEM_IUPAC_OPENEYE_NAME

Calculated IUPAC Acceptable Name-variant, using a previous IUPAC
standards, for a Compound using OpenEye, Inc.'s LexiChem
implementation and the OpenEye-style setting. For example, "1-
acetyl-2-sulfanyl-5-(2-thioxobutyl)-1,5-dihydroimidazol-4-one"

=head1 PUBCHEM_IUPAC_NAME

Calculated IUPAC Preferred Name-variant, based on the latest IUPAC
standard, for a Compound using OpenEye, Inc.'s LexiChem
implementation and the IUPAC-style setting. For example, "ethyl 2-
amino-3-ethylsulfanyl-propanoate". 

=head1 PUBCHEM_IUPAC_TRADITIONAL_NAME

Calculated IUPAC Name-variant, using a more traditional name, for a
Compound using OpenEye, Inc.'s LexiChem implementation and the
Traditional-style setting. For example, "2-amino-3-ethylthiopropanoic
acid ethyl ester".

=head1 PUBCHEM_IUPAC_SYSTEMATIC_NAME

Calculated IUPAC Name-variant, using a more systematic naming
approach that attempts to be predictive of where future IUPAC
naming conventions are headed, for a Compound using OpenEye, Inc.'s
LexiChem implementation and the Systematic-style setting. For
example, "3-ethylsulfanyl-2-methanoylamino-propanoic acid". 

=head1 PUBCHEM_IUPAC_INCHI

Calculated InChI string for a Compound using the IUPAC standard
InChI implementation (http://www.iupac.org/inchi/). For example,
"InChI=1S/C9H8O4/c1-6(10)13-8-5-3-2-4-7(8)9(11)12/h2-
5H,1H3,(H,11,12)".

=head1 PUBCHEM_IUPAC_INCHIKEY

Calculated InChIKey string for a Compound using the IUPAC standard
InChIKey implementation (http://www.iupac.org/inchi/). For
example, "BSYNRYMUTXBXSQ-UHFFFAOYSA-N". 

=head1 PUBCHEM_EXACT_MASS

Calculated exact mass corresponding to the most intense peak
observed in high resolution mass spectrometers for a Compound. For
example, "204.123583". 

=head1 PUBCHEM_MOLECULAR_FORMULA

Calculated molecular formula in Hill-format for a Compound. For
example, "C6H10N2O3S". 

=head1 PUBCHEM_MOLECULAR_WEIGHT

Calculated molecular weight for a Compound, using atomic masses
averaged according to naturally occurring abundances. For example,
"204.243519". 

=head1 PUBCHEM_MONOISOTOPIC_WEIGHT

Calculated monoisotopic molecular weight for a Compound, using only
the masses of the most abundant naturally occurring isotopes or, if
man-made, most stable isotopes. For example, "204.123583". 

=head1 PUBCHEM_TOTAL_CHARGE

Calculated total formal charge of a Compound. For example, "-1". 

=cut

my %component=();
$component{"COMPOUND_CID"}="";
$component{"COMPOUND_CANONICALIZE"}="";
$component{"CACTVS_COMPLEXITY"}="";
$component{"CACTVS_SUBSKEYS"}="";
$component{"IUPAC_OPENEYE_NAME"}="";
$component{"IUPAC_NAME"}="";
$component{"IUPAC_TRADITIONAL_NAME"}="";
$component{"IUPAC_SYSTEMATIC_NAME"}="";
$component{"IUPAC_INCHI"}="";
$component{"IUPAC_INCHIKEY"}="";
$component{"EXACT_MASS"}="";
$component{"MOLECULAR_FORMULA"}="";
$component{"MOLECULAR_WEIGHT"}="";
$component{"MONOISOTOPIC_WEIGHT"}="";
$component{"TOTAL_CHARGE"}="";
my ($field,$value,$file);

open (OUT, ">pubchem_output.tsv")||die "Output File couldn't be created";
print  OUT ("#COMPOUND_CID\tCOMPOUND_CANONICALIZED\tPUBCHEM_CACTVS_COMPLEXITY\tCACTVS_SUBSKEYS\tIUPAC_OPENEYE_NAME\tIUPAC_NAME\tIUPAC_TRADITIONAL_NAME\tIUPAC_SYSTEMATIC_NAME\tIUPAC_INCHI\tIUPAC_INCHIKEY\tEXACT_MASS\tMOLECULAR_FORMULA\tMOLECULAR_WEIGHT\tMONOISOTOPIC_WEIGHT\tTOTAL_CHARGE\n");

foreach $file (@pubchem_files){
	open(IN, $file)|| die ("no se pudo abrir el archivo ".$file);
	#print $file."\n";
	while(my $line=<IN>){
		chomp($line);
		if($line=~/> <[A-Z_]+>/){
			$field=$line;
			$field=~s/>| |<//gi;
			$field=~s/PUBCHEM_//gi;
			$value=<IN>;
			chomp($value);
			#print ($field."\n");
			$component{$field}=$value;
		}
	}
	close(IN);
	print OUT $component{"COMPOUND_CID"}."\t".$component{"COMPOUND_CANONICALIZED"}."\t".$component{"CACTVS_COMPLEXITY"}."\t".$component{"CACTVS_SUBSKEYS"}."\t".$component{"IUPAC_OPENEYE_NAME"}."\t".$component{"IUPAC_NAME"}."\t".$component{"IUPAC_TRADITIONAL_NAME"}."\t".$component{"IUPAC_SYSTEMATIC_NAME"}."\t".$component{"IUPAC_INCHI"}."\t".$component{"IUPAC_INCHIKEY"}."\t".$component{"EXACT_MASS"}."\t".$component{"MOLECULAR_FORMULA"}."\t".$component{"MOLECULAR_WEIGHT"}."\t".$component{"MONOISOTOPIC_WEIGHT"}."\t".$component{"TOTAL_CHARGE"}."\n";


	%component=();
	$component{"COMPOUND_CID"}="";
	$component{"COMPOUND_CANONICALIZED"}="";
	$component{"CACTVS_COMPLEXITY"}="";
	$component{"CACTVS_SUBSKEYS"}="";
	$component{"IUPAC_OPENEYE_NAME"}="";
	$component{"IUPAC_NAME"}="";
	$component{"IUPAC_TRADITIONAL_NAME"}="";
	$component{"IUPAC_SYSTEMATIC_NAME"}="";
	$component{"IUPAC_INCHI"}="";
	$component{"IUPAC_INCHIKEY"}="";
	$component{"EXACT_MASS"}="";
	$component{"MOLECULAR_FORMULA"}="";
	$component{"MOLECULAR_WEIGHT"}="";
	$component{"MONOISOTOPIC_WEIGHT"}="";
	$component{"TOTAL_CHARGE"}="";
}

close(OUT);

























