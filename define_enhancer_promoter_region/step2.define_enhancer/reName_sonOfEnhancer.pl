#!/usr/bin/perl
die "perl $0 finalSet_enhancer.notPC.bed\n" if(@ARGV != 1);
my $son_region_of_enhancer_bed=shift; #exon of PC region were removed;

my $son_id;
open(SREB,$son_region_of_enhancer_bed) || die;
while(my $line=<SREB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$son_id++;
	print $sub[0],"\t",$sub[1],"\t",$sub[2],"\tsonEhs_$son_id\n";
}
