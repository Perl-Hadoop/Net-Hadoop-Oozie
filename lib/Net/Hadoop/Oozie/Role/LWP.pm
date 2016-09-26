package Net::Hadoop::Oozie::Role::LWP;

use 5.014;
use strict;
use warnings;

use Carp qw( confess );
use Constant::FromGlobal DEBUG => { int => 1, default => 0, env => 1 };
use JSON::XS;
use LWP::UserAgent;
use Moo::Role;
use Scalar::Util qw( blessed );

with 'Net::Hadoop::YARN::Roles::Common';

my $json = JSON::XS->new->pretty(1)->canonical(1);

# TODO: use the one from YARN or migrate there
sub agent_request {
    my $self = shift;
    my ($uri, $method, $payload) = @_;

    print "OOZIE URI: $uri\n" if DEBUG;

    my $response; 
    if (!$method || $method eq 'get') {
        $response = $self->ua->get($uri);
    }
    elsif ($method eq 'post') {
        $response = $self->ua->post(
            $uri,
            'Content-Type' => "application/xml;charset=UTF-8",
            Content        => $payload
        );
    }
    elsif ($method eq 'put') {
        $response = $self->ua->put( $uri,
            'Content-Type' => "application/xml;charset=UTF-8",
        );
    }
    else {
        die "Unknown method";
    }

    my $content = $response->decoded_content || '';

    if ( $response->is_success ) {

        return {} if !$content;

        my $type = $response->header('content-type') || q{};

        return { response => $content } if index( lc $type, 'json' ) == -1;

        my $res;

        eval {
            $res = $json->decode($content);
            1;
        } or do {
            my $eval_error = $@ || 'Zombie error';
            confess q{server response wasn't valid JSON: } . $eval_error;
        };

        return $res;
    }

    my $info = $content =~ m{\Q<b>description</b>\E\s+<u>(.+?)</u>}xmsi
                ? "$1 "
                : '';

    confess sprintf '%s%s -> %s', $info, $response->status_line, $uri;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Net::Hadoop::Oozie::Role::LWP - User agent for Oozie requests

=head1 DESCRIPTION

Part of the Perl Oozie interface.

=head1 SYNOPSIS

    with 'Net::Hadoop::Oozie::Role::LWP';
    # TODO

head1 AUTHORS

=over 4

=item *

Burak Gursoy C<< burakE<64>cpan.org >>

=item *

David Morel C<< david.morelE<64>amakuru.net >>

=back

=head1 SEE ALSO

L<Net::Hadoop::Oozie>.

=cut
