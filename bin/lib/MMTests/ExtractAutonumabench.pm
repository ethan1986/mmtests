# ExtractAutonumabench.pm
package MMTests::ExtractAutonumabench;
use MMTests::SummariseSingleops;
our @ISA = qw(MMTests::SummariseSingleops); 
use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "ExtractAutonumabench",
		_DataType    => MMTests::Extract::DATA_TIME_SECONDS,
		_ResultData  => []
	};
	bless $self, $class;
	return $self;
}

sub initialise() {
	my ($self, $reportDir, $testName) = @_;
	$self->{_Opname} = "Time";
	$self->SUPER::initialise($reportDir, $testName);
}

sub extractReport($$$) {
	my ($self, $reportDir, $reportName) = @_;
	my ($user, $system, $elapsed, $cpu);
	my $bindTypes;

	my @files = <$reportDir/noprofile/time.*>;
	if (!@files) {
		die("Failed to open any time files\n")
	}

	my %times;

	foreach my $file (@files) {
		my @split = split /\./, $file;
		my $bindType = $split[-1];

		open(INPUT, $file) || die("Failed to open $file\n");
		$_ = <INPUT>;
		$_ =~ tr/[a-zA-Z]%//d;
		($user, $system, $elapsed, $cpu) = split(/\s/, $_);
		my ($minutes, $seconds) = split(/:/, $elapsed);
		$elapsed = $minutes * 60 + $seconds;

		$times{"User-$bindType"} = $user;
		$times{"System-$bindType"} = $system;
		$times{"Elapsed-$bindType"} = $elapsed;
		$times{"CPU-$bindType"} = $cpu;

		close INPUT;
	}

	foreach my $heading ("User", "System", "Elapsed", "CPU") {
		foreach my $key (sort(keys %times)) {
			if ($key =~ /$heading-/) {
				push @{$self->{_ResultData}}, [ $key, $times{$key} ];
			}
		}
	}
}

1;
