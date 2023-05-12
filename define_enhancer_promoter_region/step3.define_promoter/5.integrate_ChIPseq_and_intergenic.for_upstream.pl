#!/usr/bin/perl
die "perl $0 out6.upstream.improved.bed out8.leftmost_intergenic_loci.upstream.bed\n" if(@ARGV != 2);
my $leftmost_chipseq_peak_bed=shift;
my $leftmost_intergenic_bed=shift;

my %all_upstream;
my %leftmost_of_chipseq;
open(LCPB,$leftmost_chipseq_peak_bed) || die;
while(my $line=<LCPB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$leftmost_of_chipseq{$sub[3]}=$line;
	$all_upstream{$sub[3]}=1;
}

my %leftmost_of_intergenic;
open(LIB,$leftmost_intergenic_bed) || die;
while(my $line=<LIB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$leftmost_of_intergenic{$sub[3]}=$line;
	$all_upstream{$sub[3]}=1;
}

foreach my $id (keys %all_upstream){
	if(exists $leftmost_of_chipseq{$id} and exists $leftmost_of_intergenic{$id}){
		my @sub_chip=split/\s+/,$leftmost_of_chipseq{$id};
		my @sub_intergenic=split/\s+/,$leftmost_of_intergenic{$id};
		if($sub_chip[-1] eq $sub_intergenic[-1]){
			if($sub_chip[-1] eq "+"){
				if($sub_chip[2] ne $sub_intergenic[2]){
					print $id,"\tbb\n";
					die;
				}
				my $final_left_most=$sub_chip[1] < $sub_intergenic[1] ? $sub_chip[1] : $sub_intergenic[1];
				print $sub_chip[0],"\t",$final_left_most,"\t",$sub_chip[2],"\t",$sub_chip[3],"\t",$sub_chip[4],"\t",$sub_chip[5],"\n";
			}
			elsif($sub_chip[-1] eq "-"){
				if($sub_chip[1] ne $sub_intergenic[1]){
					print $id,"\taa\n";
					die;
				}
				my $final_left_most=$sub_chip[2] > $sub_intergenic[2] ? $sub_chip[2] : $sub_intergenic[2];
				print $sub_chip[0],"\t",$sub_chip[1],"\t",$final_left_most,"\t",$sub_chip[3],"\t",$sub_chip[4],"\t",$sub_chip[5],"\n";
			}
			else{
				die;
			}
		}
		else{
			die;	
		}
	}
	elsif(exists $leftmost_of_chipseq{$id} and !exists $leftmost_of_intergenic{$id}){
		print $leftmost_of_chipseq{$id},"\n";
	}
	elsif(!exists $leftmost_of_chipseq{$id} and exists $leftmost_of_intergenic{$id}){
		print $leftmost_of_intergenic{$id},"\n";
	}		
	else{
		die;
	}
}

