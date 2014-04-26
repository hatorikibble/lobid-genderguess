package Lobid::GenderGuess;

=head1 NAME

Lobid::GenderGuess - Query lobid-data to form an estimate about the gender of
a given name

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

Query lobid-data to form an estimate about the gender of
a given name

    my $Guess = Lobid::GenderGuess->new();

    $Guess->guess(Name=>'Peter');
    
    print $Guess->gender;
    print Data::Dumper::Dumper($Guess->statistics);

=head DESCRIPTION

this modules uses the lobid API (<http://api.lobid.org>) to query
German authority data with a given name and calculate a gender estimation.

=head1 METHODS

=cut

use strict;
use warnings;

our $VERSION = '0.01';

use Moose;

use JSON;
use Switch '__';
use WWW::Curl::Easy;

has 'api_base' => ( is => 'ro', isa => 'Str', default => 'http://lobid.org/' );
has 'api_path' => ( is => 'ro', isa => 'Str', default => 'person' );
has 'status'   => ( is => 'rw', isa => 'Str', default => 'OK' )
  ;    # ever the optimistic one..
has 'diagnostic' => ( is => 'rw', isa => 'Str' );
has 'gender'     => ( is => 'rw', isa => 'Str' );
has 'name'       => ( is => 'rw', isa => 'Str' );
has 'statistics' => ( is => 'rw', isa => 'HashRef' );

=head2 guess(Name=>'Sarah')

=cut

sub guess {
    my ( $self, %p ) = @_;
    my $content       = undef;
    my $query_url     = undef;
    my $Curl          = WWW::Curl::Easy->new;
    my $retcode       = undef;
    my $response_body = undef;
    my $result_ref    = undef;
    my $m_ratio       = undef;
    my $total_count   = undef;
    my $gender_count  = undef;
    my %Gender        = ( male => 0, female => 0, notKnown => 0 );
    my %Statistics    = ();

    unless ( defined( $p{Name} ) ) {
        $self->status('Error');
        $self->diagnostic('No name provided..');
        return;

    }

    $query_url =
      $self->api_base . $self->api_path . "?size=100&name=" . $p{Name};

    # $Curl->setopt( CURLOPT_HEADER, 1 );
    $Curl->setopt( CURLOPT_URL,       $query_url );
    $Curl->setopt( CURLOPT_WRITEDATA, \$response_body );

    $retcode = $Curl->perform;

    unless ( $retcode == 0 ) {

        $self->status('Error');
        $self->diagnostic(
            'Error while getting $query_url: ' . $Curl->strerror($retcode) );
    }

    $result_ref = decode_json($response_body);

    #print Dumper($result_ref);
    foreach my $item ( @{$result_ref} ) {
        $total_count++;

        #print $item->{'@graph'}->[0]->{'preferredNameForThePerson'};
        if (   ( defined( $item->{'@graph'}->[0]->{'gender'} ) )
            && ( $item->{'@graph'}->[0]->{'gender'} =~ /\#(.+?)$/ ) )
        {
            $gender_count++;
            if ( exists( $Gender{$1} ) ) {
                $Gender{$1}++;
            }
            else {    # maybe more than female,male,unknown?
                $Gender{$1} = 1;

            }

        }

    }

    $self->name( $p{Name} );

    # adopt binary working hypothesis..
    $m_ratio = ( 100 / ( $Gender{male} + $Gender{female} ) ) * $Gender{male};

    $Statistics{TotalCount}            = $total_count;
    $Statistics{GenderCount}           = $gender_count;
    $Statistics{GenderDistribution}    = \%Gender;
    $Statistics{GenderRatio}->{Male}   = $m_ratio;
    $Statistics{GenderRatio}->{Female} = 100 - $m_ratio;

    # define 40-80% corridor arbitrarily
    switch ($m_ratio) {

        case __ < 40 { $self->gender('female'); }
        case __ > 80 { $self->gender('male'); }

        else { $self->gender('unknown'); }
    }

    $self->statistics( \%Statistics );

}

=head1 AUTHOR

Peter Mayr, C<< <at.peter.mayr at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-lobid-genderguess at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lobid-GenderGuess>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lobid::GenderGuess


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Lobid-GenderGuess>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Lobid-GenderGuess>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Lobid-GenderGuess>

=item * Search CPAN

L<http://search.cpan.org/dist/Lobid-GenderGuess/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Peter Mayr.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of Lobid::GenderGuess
