##.pl <y_1116_vs_y_1718.windowed.weir.fst> <y_1116.windowed.pi> <y_1718.windowed.pi>
use strict;
use autodie;

my($fst,$pi_a,$pi_b,$fst_cut,$pi_cut) = @ARGV;
unless (-d 'tmp')
{
	mkdir "tmp" or die $!;
}
else {unlink glob "tmp/*"}

PI_FILE_SPLIT($pi_a);
PI_FILE_SPLIT($pi_b);

$a = $pi_a; $b = $pi_b;

$a =~ s/\.windowed\.pi\Z//;
$b =~ s/\.windowed\.pi\Z//;

print "chrom\tbin_start\tbin_end\tn_variants\tweighted_fst\tmean_fst\tpi_a($a)\tpi_b($b)\tlog2(pi_a/pi_b)\tfst\n";
my $note_chr;
my %pia_bin_pi; my %pib_bin_pi;
open FST,"$fst" or die $!;
while (my $line = <FST>)
{
	chomp($line);
	my ($chr,$bin_start,$bin_end,$fst) = (split /\t/,$line)[0,1,2,4];
	if($chr eq 'CHROM'){next;}
	if($fst < 0) {next;}

	if($note_chr ne $chr)
	{
		%pia_bin_pi = (); %pib_bin_pi = ();	
		my $file = "tmp/$pi_a".'_'.$chr;
		%pia_bin_pi = %{READ_PI_SPLIT_IN($file)};
		my $file = "tmp/$pi_b".'_'.$chr;
		%pib_bin_pi = %{READ_PI_SPLIT_IN($file)};
		$note_chr = $chr;
		redo;
	}
	
	my $ratio;
	my $ka = $bin_start.'-'.$bin_end; my $kb = $bin_start.'-'.$bin_end;
	if(($pia_bin_pi{$bin_start.'-'.$bin_end} != 0) && ($pib_bin_pi{$bin_start.'-'.$bin_end} != 0))

	{
		$ratio = log($pia_bin_pi{$ka}/$pib_bin_pi{$kb})/log(2);
	}
	print "$line\t$pia_bin_pi{$ka}\t$pib_bin_pi{$kb}\t$ratio\t$fst\n";
}
close FST;
unlink glob "tmp/*";
rmdir "tmp";

sub READ_PI_SPLIT_IN {
	my ($pi_file) = @_;
	my %hash;
	open PI_FILE,"$pi_file" or die $!;
	while (my $line = <PI_FILE>)
	{
		chomp($line);
		my ($bin_s,$bin_e,$pi) = (split /\t/,$line)[1,2,-1];
		my $key = $bin_s.'-'.$bin_e;
		$hash{$key} = $pi;
	}
	close PI_FILE;	
	return \%hash;
}

sub PI_FILE_SPLIT {
	my ($get_pi) = @_;

	my $fh; my $note_chr = 'no';
	open PI,"$get_pi" or die $!;
	while (my $line = <PI>)
	{
		my ($chr) = split /\t/,$line;
		if($chr eq 'CHROM'){next;}
		elsif($chr eq $note_chr)
		{
			print $fh "$line";
		}
		else
		{
			if($note_chr ne 'no')
			{
				close $fh;
			}
			my $file_id = $get_pi.'_'.$chr;
			open $fh,">>tmp/$file_id" or die $!;
			print $fh "$line";

			$note_chr = $chr;
		}
	}
	close $fh;
	close PI;
}
