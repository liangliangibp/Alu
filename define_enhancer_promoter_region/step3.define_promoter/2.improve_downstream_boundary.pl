#!/usr/bin/perl
die "perl $0 HeLaS3.prmt.anno.bed\n" if(@ARGV != 1);
my $prmt_anno_bed=shift;

my %promoter_boundary;
open(PAB,$prmt_anno_bed) || die;
while(my $line=<PAB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	my $raw_promoter_id=join"\t",@sub[0..5];
	if($sub[5] eq "+"){
		$promoter_boundary{$raw_promoter_id}{5}=$sub[1];
	}
	elsif($sub[5] eq "-"){
		$promoter_boundary{$raw_promoter_id}{5}=$sub[2];
	}

	if($sub[5] eq "+"){
		if($sub[9] > $promoter_boundary{$raw_promoter_id}{3}){
			$promoter_boundary{$raw_promoter_id}{3}=$sub[9];
		}
	}
	elsif($sub[5] eq "-"){
		if(exists $promoter_boundary{$raw_promoter_id}{3} and $sub[8] < $promoter_boundary{$raw_promoter_id}{3}){
			$promoter_boundary{$raw_promoter_id}{3}=$sub[8];
		}
		elsif(!exists $promoter_boundary{$raw_promoter_id}{3}){
			$promoter_boundary{$raw_promoter_id}{3}=$sub[8];
		}
		else{
			next;
		}
	}
}

foreach my $raw_promoter_id (sort keys %promoter_boundary){
	my @sub=split/\s+/,$raw_promoter_id;
	if($sub[-1] eq "+"){
		if(!exists $promoter_boundary{$raw_promoter_id}{3}){#no peaks in the upstream
			next;
		}
		if($promoter_boundary{$raw_promoter_id}{3} > $sub[2]){
			$promoter_boundary{$raw_promoter_id}{3}=$sub[2];
		}
		print $sub[0],"\t",$promoter_boundary{$raw_promoter_id}{5},"\t",$promoter_boundary{$raw_promoter_id}{3},"\t";
		print $sub[3],"\t",255,"\t",$sub[5],"\n";
	}	
	elsif($sub[-1] eq "-"){
		if(!exists $promoter_boundary{$raw_promoter_id}{3}){#no peaks in the upstream
			next;
		}
		if($promoter_boundary{$raw_promoter_id}{3} < $sub[1]){
			$promoter_boundary{$raw_promoter_id}{3}=$sub[1];
		}
		print $sub[0],"\t",$promoter_boundary{$raw_promoter_id}{3},"\t",$promoter_boundary{$raw_promoter_id}{5},"\t";
		print $sub[3],"\t",255,"\t",$sub[5],"\n";
	}
	else{
		print $raw_promoter_id,"\n";
		die;
	}
}
