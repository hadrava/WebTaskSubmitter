package CMark;

use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

our $VERSION   = 1.00;
our @ISA       = qw(Exporter);
our @EXPORT    = qw();
our @EXPORT_OK = qw(markdown);

use IPC::Open2;


sub markdown {
	my ($md) = @_;

	my ($html, $fin, $fout);

	my $pid = open2($fout, $fin, 'lib/bin/cmark', '--safe')
		or die "open2() failed $!";

	print $fin $md;
	close($fin);
	waitpid $pid, 0;
	$html = "";
	foreach my $line (<$fout>) {
		$html .= $line;
	}

	return $html

}

1;
