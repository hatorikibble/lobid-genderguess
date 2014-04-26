#!/usr/bin/env perl

use strict;
use warnings;

use lib "../lib";


#use Data::Dumper;
use Lobid::GenderGuess;

my $Guess = Lobid::GenderGuess->new();

$Guess->guess(Name=>$ARGV[0]);

print $Guess->gender;



print Data::Dumper::Dumper($Guess->statistics);

