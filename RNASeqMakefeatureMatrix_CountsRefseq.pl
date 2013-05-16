#Make matrix of count data RefSeq and transcripts only
#luciap

my $dir=shift;

opendir DIR, $dir or die "cannot open dir $dir:$!";
my @files = grep { $_ ne '.' && $_ ne '..' } readdir DIR;
@files= sort @files;
my $nfiles=@files;
print "this are the number $nfiles\n";

closedir DIR;


my $outfile=$dir."RNASEq_Counts_RefSeq.txt";
open OUT, ">$outfile" or die $!;
print OUT "GeneID\t";

my @hashesofcounts;
for my $num (@files){
	push @hashesofcounts, {}
}


local $/ = "--------------------------------------------------------------------";


my $i=0;

foreach my $files(@files){
	print OUT "$files\t";
	open IN, "<$dir/$files" or die $!;
	while (<IN>){
		if (/(\S+refseq\))/){
			my $ID=$1;
			my @info= split ('\n', $_);
			my $line=$info[3];
		
			if ($line=~/transcript\s+chr\S+\s+\S+\s+\S+\s+(\S+)/){
				my $UCount=$1;
				$hashesofcounts[$i]{$ID}="$UCount";
			}
		}
	}
	close IN;
	$i++;
}
print OUT "\n";



#Now make the matrix of genes and Counts


open IN1, "<$dir/$files[0]" or die $!;
my $b;

while (<IN1>){
	if (/(\S+refseq\))/){
		my $GeneID=$1;
		print "working on transcript $GeneID\n";
		print OUT "$GeneID\t";
		for ($b=0;$b<$nfiles;$b++){
			my $match=$hashesofcounts[$b]{$GeneID};
			print OUT "$match\t";
		}
		print OUT "\n";
	}
}

	