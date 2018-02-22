#!/usr/bin/perl

use common::sense;

# To load packages from current directory
use FindBin;
use lib "$FindBin::Bin/lib";

use CMark 'markdown';
use DBI;

# Configuration for WebTaskSubmitter:
my $db_file = "data/webtaskdb.sqlite";

my $dsn = "DBI:SQLite:$db_file";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;


my $sth = $dbh->prepare('SELECT * FROM comments');
$sth->execute();
my $hashref = $sth->fetchall_hashref('cid');
for my $key (keys $hashref) {
	my $html = markdown($hashref->{$key}->{text});

	my $sth = $dbh->prepare('UPDATE comments SET html=? WHERE cid=?');
	$sth->execute($html, $key) or die "Cannot update comment cid=$key: $DBI::errstr"

}
