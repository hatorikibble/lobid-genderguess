#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Moose;

plan tests => 12;

use_ok('Lobid::GenderGuess') || print "Bail out!\n";


my $Guess = Lobid::GenderGuess->new();

foreach my $attr (qw(api_base api_path status diagnostic gender name statistics)) {
    has_attribute_ok( $Guess, $attr, "Object has attribute '$attr'..." );
}

$Guess->guess(Name=>'Peter');

is($Guess->status,'OK',"Status check...");
is($Guess->gender,'male',"Gender for 'Peter' is 'male'...");

$Guess->guess(Name=>'Miriam');

is($Guess->status,'OK',"Status check...");
is($Guess->gender,'female',"Gender for 'Miram' is 'female'...");
