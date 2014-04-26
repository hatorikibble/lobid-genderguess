
Lobid::GenderGuess
===================

Lobid::GenderGuess - Query lobid-data to form an estimate about the gender of
a given name

VERSION
-------

Version 0.01

SYNOPSIS
--------

Query lobid-data to form an estimate about the gender of
a given name

    my $Guess = Lobid::GenderGuess->new();

    $Guess->guess(Name=>'Peter');
    
    print $Guess->gender;
    print Data::Dumper::Dumper($Guess->statistics);

DESCRIPTION
-----------

this modules uses the lobid API (<http://api.lobid.org>) to query
German authority data with a given name and calculate a gender estimation.
