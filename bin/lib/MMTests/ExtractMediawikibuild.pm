# ExtractMediawikibuild.pm
package MMTests::ExtractMediawikibuild;
use MMTests::SummariseVariableops;
use VMR::Report;
our @ISA = qw(MMTests::SummariseVariableops);

use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "ExtractMediawikibuild",
		_DataType    => DataTypes::DATA_TRANS_PER_SECOND,
		_ResultData  => [],
		_PlotType    => "simple",
	};

	bless $self, $class;
	return $self;
}

sub extractReport() {
	my ($self, $reportDir, $reportName, $profile) = @_;

	my $file = "$reportDir/$profile/import-mwdump.log";
	open(INPUT, $file) || die("Failed to open $file\n");
	my $nr_sample = 0;
	while (<INPUT>) {
		my $line = $_;

		next if $line !~ /[0-9,]+ pages \(([0-9,.]+)\/sec\),/;
		my $val = $1;
		$val =~ s/,//;
		push @{$self->{_ResultData}}, ["Pages/sec", $nr_sample++, $val];
	}

	$self->{_Operations} = [ "Pages/sec" ];
	close INPUT;
}
1;
