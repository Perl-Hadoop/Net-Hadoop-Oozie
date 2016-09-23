package Net::Hadoop::Oozie::Role::Common;

use 5.18.2;
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
