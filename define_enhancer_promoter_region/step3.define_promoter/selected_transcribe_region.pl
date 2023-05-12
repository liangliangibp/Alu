#!/usr/bin/perl
die "perl $0 Result_Step8_feature_and_other.bed\n" if(@ARGV != 1);
my $all_ele=shift;


open(RNA,">produce_RNA.bed") || die;
open(DNA,">without_RNA.bed") || die;

open(AE,$all_ele) || die;
while(my $line=<AE>){
	chomp $line;
	my @sub=split/\s+/,$line;
	my @anno=split/_/,$sub[3];
	shift @anno;
	shift @anno;
	my $is_transcribed;
	foreach (@anno){
		if(/CDS/ or /UTR/ or /exon/){
			$is_transcribed=1;
			last;
		}
	}
	if($is_transcribed){
		print RNA $line,"\n";
	}
	else{
		print DNA $line,"\n";
	}
}
