#!/usr/bin/perl
die "perl $0 stitched_enhancer.count.bed countCutoff\n" if(@ARGV != 2);
my $stitched_enhancer_bed=shift;
my $cutoff=shift;

my $SE_id;
my $TE_id;
open(SEB,$stitched_enhancer_bed) || die;
while(my $line=<SEB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	if($sub[4] >= $cutoff){	#cutoff defined by gridRsub.getSuperEnhancerCutoff.R
		$SE_id++;
		print $sub[0],"\t",$sub[1],"\t",$sub[2],"\tSE_$SE_id\n";
	}
	else{
		$TE_id++;
		print $sub[0],"\t",$sub[1],"\t",$sub[2],"\tTE_$TE_id\n";
	}
}
	
