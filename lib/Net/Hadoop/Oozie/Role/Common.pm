package Net::Hadoop::Oozie::Role::Common;

use 5.010;
use strict;
use warnings;

use Carp qw(
    confess
);

use Carp ();
use Regexp::Common qw( URI number );

use Moo::Role;

has 'oozie_uri' => (
    is => 'rw',

    # The very least we can do to check the URL; since we use -keep we could
    # run more checks on the hostname, port, etc
    isa => sub {
        my $thing = shift;
        if ( $thing !~ $RE{URI}{HTTP}{-keep}{ -scheme => 'https?' } ) {
            Carp::confess "'$thing' is not a valid Oozie URI";
        }
    },
    default => sub {
        my $self = shift;
        if ( my $env = $ENV{OOZIE_URL} ) {
            # TODO
            #if ( $env !~ m{ \A https?:// (.+?) [/] oozie \z }xms ) {
            #    die "OOZIE_URL=$env is a malformed value!";
            #}
            return $env;
        }
        Carp::confess "oozie_uri not specified and \$ENV{OOZIE_URL} is not set!";
    },
    lazy => 1,
);

1;

__END__


=pod

=encoding utf8

=head1 NAME

Net::Hadoop::Oozie::Role::Common - Common methods for Oozie

=head1 DESCRIPTION

Part of the Perl Oozie interface.

=head1 SYNOPSIS

    with 'Net::Hadoop::Oozie::Role::Common';
    # TODO

=head1 AUTHORS

=over 4

=item *

Burak Gursoy C<< burakE<64>cpan.org >>

=item *

David Morel C<< david.morelE<64>amakuru.net >>

=back

=head1 SEE ALSO

L<Net::Hadoop::Oozie>.

=cut
