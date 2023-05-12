#!/usr/bin/perl 
die "perl $0 enhancer.feature_count.bed\n" if(@ARGV != 1);
my $enhancer_feature_count=shift;

my %stitched_enhancer;
open(EFC,$enhancer_feature_count) || die;
while(my $line=<EFC>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$sub[3]=~s/ECID://;
	if(exists $stitched_enhancer{$sub[3]}){
		if($sub[0] eq $stitched_enhancer{$sub[3]}{0}){
			if($sub[1] < $stitched_enhancer{$sub[3]}{1}){
				$stitched_enhancer{$sub[3]}{1}=$sub[1];
			}
			if($sub[2] > $stitched_enhancer{$sub[3]}{2}){
				$stitched_enhancer{$sub[3]}{2}=$sub[2];
			}
			$stitched_enhancer{$sub[3]}{3}+=$sub[5];
		}
		else{
			print $line,"\taaa\n";
			die;
		}
	}
	else{
		$stitched_enhancer{$sub[3]}{0}=$sub[0];	
		$stitched_enhancer{$sub[3]}{1}=$sub[1];
		$stitched_enhancer{$sub[3]}{2}=$sub[2];
		$stitched_enhancer{$sub[3]}{3}=$sub[5];
	}
}

foreach my $id (sort {$a<=>$b} keys %stitched_enhancer){
	foreach (0..3){
		if($_ == 3){
			print "ECID:$id\t",$stitched_enhancer{$id}{3},"\n";
		}
		else{
			print $stitched_enhancer{$id}{$_},"\t";
		}
	}
}
	
