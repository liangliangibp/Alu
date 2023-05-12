#!/usr/bin/perl
die "perl $0 prmt.anno.bed\n" if(@ARGV != 1);
my $prmt_anno_bed=shift;

my %farest_intergenic_loci;
open(PAB,$prmt_anno_bed) || die;
while(my $line=<PAB>){
	chomp $line;
	my @sub=split/\s+/,$line;
	my $raw_promoter_id=join"\t",@sub[0..5];
	if($sub[5] eq "+"){
		if($sub[8] ne $sub[2]){
			next;	
		}
		my $left_most = $sub[7] < $sub[1] ? $sub[1] : $sub[7];
		if(exists $farest_intergenic_loci{$raw_promoter_id} and $left_most < $farest_intergenic_loci{$raw_promoter_id}){
			$farest_intergenic_loci{$raw_promoter_id} =$left_most;
		}
		elsif(!exists $farest_intergenic_loci{$raw_promoter_id}){
			$farest_intergenic_loci{$raw_promoter_id} =$left_most;
		}
		else{
			next;
		}
	}
	elsif($sub[5] eq "-"){
		if($sub[7] ne $sub[1]){
			next;	
		}
		my $left_most = $sub[8] > $sub[2] ? $sub[2] : $sub[8];
		if(exists $farest_intergenic_loci{$raw_promoter_id} and $left_most > $farest_intergenic_loci{$raw_promoter_id}){
			$farest_intergenic_loci{$raw_promoter_id} =$left_most;
		}
		elsif(!exists $farest_intergenic_loci{$raw_promoter_id}){
			$farest_intergenic_loci{$raw_promoter_id} =$left_most;
		}
		else{
			next;
		}
	}
	else{
		die;
	}
}

foreach my $raw_promoter_id (sort keys %farest_intergenic_loci){
	my @sub=split/\s+/,$raw_promoter_id;
	if($sub[5] eq "+"){
		if(exists $farest_intergenic_loci{$raw_promoter_id}){	#no intergenic region in upstream
			print $sub[0],"\t",$farest_intergenic_loci{$raw_promoter_id},"\t",$sub[2],"\t",$sub[3],"\t",$sub[4],"\t",$sub[5],"\n";
		}
		else{
			next;
		}
	}
	elsif($sub[5] eq "-"){
		if(exists $farest_intergenic_loci{$raw_promoter_id}){	#no intergenic region in upstream
			print $sub[0],"\t",$sub[1],"\t",$farest_intergenic_loci{$raw_promoter_id},"\t",$sub[3],"\t",$sub[4],"\t",$sub[5],"\n";
		}
		else{
			next;
		}
	}
	else{
		die;
	}
}
