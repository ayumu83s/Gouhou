use strict;
use warnings;
use Test::More;
use Test::MockTime qw(set_fixed_time restore_time);
use Gouhou;
use Data::Dumper;
use Time::Local;

sub timepiece2fixed_time {
    my $t = shift;
    return timelocal(
        $t->sec,
        $t->min,
        $t->hour,
        $t->mday,
        $t->_mon,   # month - 1
        $t->_year,  # year - 1900
    );
}

subtest 'new' => sub {
    my $gouhou = Gouhou->new(+{
        consumer_key        => 'consumer_key',
        consumer_secret     => 'consumer_secret',
        access_token        => 'access_token',
        access_token_secret => 'access_token_secret',
    });
    isa_ok $gouhou, 'Gouhou';
    isa_ok $gouhou->{net}, 'Net::Twitter';
};

subtest 'is_start' => sub {
    my $gouhou = Gouhou->new(+{
        consumer_key        => 'consumer_key',
        consumer_secret     => 'consumer_secret',
        access_token        => 'access_token',
        access_token_secret => 'access_token_secret',
    });
    subtest '水曜日' => sub {
        my $t = Time::Piece->strptime('2014/1/1 00:00:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_start, undef);
        restore_time();
    };
    subtest '木曜日の0：00' => sub {
        my $t = Time::Piece->strptime('2014/1/2 00:00:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_start, undef);
        restore_time();
    };
    subtest '木曜日の0：05' => sub {
        my $t = Time::Piece->strptime('2014/1/2 00:05:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_start, 1);
        restore_time();
    };
    subtest '金曜日の0：05' => sub {
        my $t = Time::Piece->strptime('2014/1/3 00:05:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_start, undef);
        restore_time();
    };
};

subtest 'is_end' => sub {
    my $gouhou = Gouhou->new(+{
        consumer_key        => 'consumer_key',
        consumer_secret     => 'consumer_secret',
        access_token        => 'access_token',
        access_token_secret => 'access_token_secret',
    });
    subtest '水曜日' => sub {
        my $t = Time::Piece->strptime('2014/1/1 00:00:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_end, undef);
        restore_time();
    };
    subtest '金曜日の0：00' => sub {
        my $t = Time::Piece->strptime('2014/1/3 00:00:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_end, undef);
        restore_time();
    };
    subtest '金曜日の0：05' => sub {
        my $t = Time::Piece->strptime('2014/1/3 00:05:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_end, 1);
        restore_time();
    };
    subtest '土曜日の0：05' => sub {
        my $t = Time::Piece->strptime('2014/1/4 00:05:00', '%Y/%m/%d %H:%M:%S');
        my $fixed_time = timepiece2fixed_time($t);
        set_fixed_time($fixed_time);
        is($gouhou->is_end, undef);
        restore_time();
    };
};
done_testing;

