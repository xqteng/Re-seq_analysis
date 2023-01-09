## .pl <CH-50_samples_combined_LG1.filtered_snp.hard.filtered.tbl>
use strict;
use autodie;

my ($tbl_file) = @ARGV;

my @samples;
my %seqs;

open TBL,"$tbl_file" or die;
while (my $line = <TBL>)
{
	chomp($line);
	
	$line =~ s/ +/\t/g;
	$line =~ s/\t+/\t/g;


	my @tmp = split /\t/,$line;
	splice @tmp,0,2;

	if($line =~ /\A#/)
	{
		@samples = @tmp;
		next;
	}

	if(scalar@samples != scalar@tmp){next}

	my %check;
	for(my $i=0;$i<=$#tmp;$i++)
	{
		$check{$tmp[$i]}++;
	}
	if((keys %check) ==1){next}

	for(my $i=0;$i<=$#tmp;$i++)
	{
		$seqs{$i} .= $tmp[$i];
	}
}
close TBL;

foreach my $s (sort keys %seqs)
{
	print ">$samples[$s]\n$seqs{$s}\n";
}
