use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok("Net::Hadoop::Oozie");
}

SKIP: {
    skip "No OOZIE_URL in environment", 1 if ! $ENV{OOZIE_URL};

    my $oozie = Net::Hadoop::Oozie->new;
    # just trigger a request as a simple test
    my $build = $oozie->build_version;

    ok( 1, 'Tests are not yet implemented ...');
}

done_testing();
