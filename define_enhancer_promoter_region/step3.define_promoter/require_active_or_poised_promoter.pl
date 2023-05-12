#!/usr/bin/perl
die "perl $0 prmt.bed\n" if(@ARGV != 1);
my $raw_promoter_bed=shift;

open(RPB,$raw_promoter_bed) || die;
while(my $line=<RPB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	if($sub[4] > 0){
		print $line,"\n";
	}
}
