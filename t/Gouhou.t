use strict;
use Test::More;
use Gouhou;

subtest 'new' => sub {
    my $gouhou = Gouhou->new(
        consumer_key        => 'consumer_key',
        consumer_secret     => 'consumer_secret',
        access_token        => 'access_token',
        access_token_secret => 'access_token_secret',
    );
    isa_ok $gouhou, 'Gouhou';
    isa_ok $gouhou->{net}, 'Net::Twitter';
};

done_testing;

