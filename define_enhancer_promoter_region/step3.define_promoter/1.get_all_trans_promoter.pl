#!/usr/bin/perl
die "perl $0 gencode.v19.annotation.gtf\n" if(@ARGV != 1);
my $gtf=shift;

my $promoter_len=5000;

open(OUTA,">out1.upstream.bed") || die;
open(OUTB,">out2.downstream.bed") || die;
open(IN,$gtf) || die;
while(my $line=<IN>){
        chomp $line;
        if($line=~/^#/){
                next;
        }
        else{
                my @sub=split/\s+/,$line;
                if($sub[2] eq "transcript"){
                        my $gene_name=read_gene_name($line);
                        my $trans_type=read_transcript_type($line);
                        my $trans_id=read_transcript_id($line);
			my $gene_type=read_gene_type($line);
                        if($gene_type eq "protein_coding" and $trans_type ne "protein_coding"){#nonCoding trans from PCgene
                        	next;
			}
                        if($trans_type and $trans_id){
				if($sub[6] eq "+"){
					my $prmt_start=$sub[3]-$promoter_len;
					my $prmt_end=$sub[3]+$promoter_len;
					$prmt_start = $prmt_start < 0 ? 0 : $prmt_start;
					$prmt_end = $prmt_end > $sub[4] ? $sub[4] : $prmt_end;
					print OUTA $sub[0],"\t",$prmt_start,"\t",$sub[3],"\t",$trans_id,"_$gene_name\t255\t",$sub[6],"\n";
					print OUTB $sub[0],"\t",$sub[3],"\t",$prmt_end,"\t",$trans_id,"_$gene_name\t255\t",$sub[6],"\n";
				}
				elsif($sub[6] eq "-"){
					my $prmt_start=$sub[4]-$promoter_len;
					my $prmt_end=$sub[4]+$promoter_len;
					$prmt_start = $prmt_start < $sub[3] ? $sub[3] : $prmt_start;
					print OUTA $sub[0],"\t",$sub[4],"\t",$prmt_end,"\t",$trans_id,"_$gene_name\t255\t",$sub[6],"\n";
					print OUTB $sub[0],"\t",$prmt_start,"\t",$sub[4],"\t",$trans_id,"_$gene_name\t255\t",$sub[6],"\n";
				}
				else{
					die;
				}
                        }
                        else{
                                warn $line;
                                die "wrong gtf line\n";
                        }
                }
        }
}

sub read_gene_name{
        my $in=shift;
        my @info=split/\s+/,$in;
        foreach (1..8){shift @info};
        foreach my $i (0..$#info){
                if($info[$i] eq "gene_name"){
                        my $out=$info[$i+1];
                        $out=~s/^"//;
                        $out=~s/";$//;
                        return $out;
                }
        }
}

sub read_transcript_id{
        my $in=shift;
        my @info=split/\s+/,$in;
        foreach (1..8){shift @info};
        foreach my $i (0..$#info){
                if($info[$i] eq "transcript_id"){
                        my $out=$info[$i+1];
                        $out=~s/^"//;
                        $out=~s/";$//;
                        return $out;
                }
        }
}



sub read_transcript_type{
        my $in=shift;
        my @info=split/\s+/,$in;
        foreach (1..8){shift @info};
        foreach my $i (0..$#info){
                if($info[$i] eq "transcript_type"){
                        my $out=$info[$i+1];
                        $out=~s/^"//;
                        $out=~s/";$//;
                        return $out;
                }
        }
}

sub read_gene_type{
        my $in=shift;
        my @info=split/\s+/,$in;
        foreach (1..8){shift @info};
        foreach my $i (0..$#info){
                if($info[$i] eq "gene_type"){
                        my $out=$info[$i+1];
                        $out=~s/^"//;
                        $out=~s/";$//;
                        return $out;
                }
        }
}

