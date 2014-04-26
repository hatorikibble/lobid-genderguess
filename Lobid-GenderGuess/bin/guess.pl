#!/usr/bin/env perl

use strict;
use warnings;

use lib "../lib";


use Data::Dumper;
use Lobid::GenderGuess;

my $Guess = Lobid::GenderGuess->new();

$Guess->guess(Name=>$ARGV[0]);

print "'$ARGV[0]' is probably '".$Guess->gender."'\n\n";



print "Here's the statistics data that I've used: ".Dumper($Guess->statistics);

