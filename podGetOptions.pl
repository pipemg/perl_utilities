#!/usr/local/bin/perl

=pod

=head1 NAME

podGetOptions.pl

=head1 AUTHOR AND DATE

definog, Sep 26, 2010

=head1 PATH

/home/delfinog

=head1 VERSION

1.0

=head1 DESCRIPTION

Script ejemplo1

=head1 INPUT FORMAT

=head1 OUTPUT FORMAT

=head1 OPTIONS OR PARAMETERS

=over 4

=item B<-f>  Input file

=item B<-h>  Help on line

=back

=head1 EXAMPLE(S)

=head1 REQUIREMENTS

=cut

use strict;
use Getopt::Long;
my %opts = ();
GetOptions (\%opts,'f=s',
		   'option1=s',
		   'option2=i',
		   'h|help');

##################################################################
#### Si el hash %opts, esta vacío despliega una ayuda rápida	##
##################################################################
if(scalar(keys(%opts)) == 0){
   print "usage:	   podGetOptions.pl [options]\n";
   print "-f		   Input file\n";
   print "-option1	   option1\n";
   print "-option2	   option2\n";
   print "-h | -help	   Help\n";
   exit;
}

if($opts{'h'}){
   &PrintHelp;
}


##################################################################
#### Despliega la ayuda en linea con opcion -h o -help	        ##
##################################################################
sub PrintHelp {
   system "pod2text -c $0 ";
   exit()
}
