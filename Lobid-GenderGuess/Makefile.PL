use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Lobid::GenderGuess',
    AUTHOR             => q{Peter Mayr <at.peter.mayr@gmail.com>},
    VERSION_FROM       => 'lib/Lobid/GenderGuess.pm',
    ABSTRACT_FROM      => 'lib/Lobid/GenderGuess.pm',
    LICENSE            => 'Artistic_2_0',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::Moose' => 0,
        'Test::More'  => 0,
    },
    PREREQ_PM => {
        'JSON'   => 2.90,
        'Moose'  => 2.12,
        'Switch' => 2.17,
        'WWW::Curl' => 2.15,

    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Lobid-GenderGuess-*' },
);
