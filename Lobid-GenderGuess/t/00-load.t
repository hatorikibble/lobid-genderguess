#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Lobid::GenderGuess' ) || print "Bail out!\n";
}

diag( "Testing Lobid::GenderGuess $Lobid::GenderGuess::VERSION, Perl $], $^X" );
