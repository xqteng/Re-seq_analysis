## .pl </home/yinglu/pl/liyalin/data/AmbiguityCodes> <vcf_file> [distance between 2 snp]
## .pl /home/yinglu/CH/genome_corrected/corrected_genome_final/reseq_vcf/50_sample_combined_gvcf/LG_vcf/CH-50_samples_combined_LG1.hard.filtered.snp.vcf
use strict;
use autodie;

my ($Ambiguitycode_file,$vcf_file,$distance) = @ARGV;
my $i=0;

if($distance){;}
else{$distance=0}

my %code;
open CODE,"$Ambiguitycode_file" or die $!;
while (my $line = <CODE>)
{
	$line =~ s/ \+/\t/g;
	$line =~ s/\t+/\t/g;

        if($line =~ /\A#/){next}

	chomp($line);
        my ($code,$nucleotides) = (split /\t/,$line)[-1,-2];
        $code{$nucleotides} = $code;
}
close CODE;

my @samples;
open VCF,"$vcf_file" or die $!;
while (my $line = <VCF>)
{
	chomp($line);
	if($line =~ /\A##/)
	{
		next;
	}

	if($line =~ /\A#CHROM/)
	{
		@samples = split /\t/,$line;
		
		splice @samples,0,9;

		print "#CHROM\tPOS\tREF\t";
		map{print "$_\t"}@samples;
		print "\n";
	}
	else
	{
		if($i == $distance)	
		{
			$i = 0;
			my @tmp = split /\t/,$line;
			my ($chrom,$pos,$ref,$alt) = (@tmp)[0,1,3,4];
			
			splice @tmp,0,9;
			my $sample_seq = &samples_data_process(\@tmp,$ref,$alt);
			if ($sample_seq)
			{
				print "$chrom\t$pos\t$ref\t$sample_seq\n";
			}
		}
		else
		{
			$i++;
			next;
		}
	}
}
close VCF;

sub samples_data_process {
	my ($get_data,$get_ref,$get_alt)= @_;
	my @alt_word = split /,/,$get_alt;

	for(my $i=0;$i<=$#alt_word;$i++)
	{
		if($alt_word[$i] eq '*')
		{
			my $different = splice @alt_word,$i,1;
			my $alt_others = join ',',@alt_word;
			$alt_others .= ','.$get_ref;
			my $different = $code{$alt_others};
			splice @alt_word,$i,0,$different;
			last;
		}
	}

	my @bases = ($get_ref,@alt_word);

	my $sample_seq;
#	my ($sample_seq_1,$sample_seq_2);
	my $flag = 'n';
	foreach my $sample (@$get_data)
	{
		my ($gt,$ad) = (split /:/,$sample)[0,1];
		my ($gt_1,$gt_2) = split /[\/\|]/,$gt;

		if($gt_1 != $gt_2)
		{
			$flag = 'y';
		}
#		$sample_seq .= $bases[$gt_1].$bases[$gt_2]."\t";
		$sample_seq .= $bases[$gt_1]."\t";
	}
	if($flag eq 'y')
	{
#		return ($sample_seq);
		return 0;
	}
	else
	{
		return $sample_seq;
#		my @tmp = split /\t/,$sample_seq;
#		my $sample_seq;
#		foreach my $t (@tmp)
#		{
#			$sample_seq .= (split //,$t)[0]."\t";
#		}
#		return $sample_seq;
	}
}
