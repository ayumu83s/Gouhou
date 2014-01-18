use strict;
use warnings;
use Test::More;
use Test::MockTime qw(set_fixed_time restore_time);
use Gouhou;
use Data::Dumper;
use Time::Piece;
use Config::Pit;

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
        my $t = localtime(Time::Piece->strptime('2014/1/1 00:00:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_start, undef);
        restore_time();
    };
    subtest '木曜日の0：00' => sub {
        my $t = localtime(Time::Piece->strptime('2014/1/2 00:00:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_start, undef);
        restore_time();
    };
    subtest '木曜日の0：05' => sub {
        my $t = localtime(Time::Piece->strptime('2014/1/2 00:05:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_start, 1);
        restore_time();
    };
    subtest '金曜日の0：05' => sub {
        my $t = localtime(Time::Piece->strptime('2014/1/3 00:05:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
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
        my $t = localtime(Time::Piece->strptime('2014/1/1 00:00:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_end, undef);
        restore_time();
    };
    subtest '金曜日の0：00' => sub {
        my $t = localtime(Time::Piece->strptime('2014/1/3 00:00:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_end, undef);
        restore_time();
    };
    subtest '金曜日の0：05' => sub {
        my $t = localtime(Time::Piece->strptime('2014/1/3 00:05:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_end, 1);
        restore_time();
    };
    subtest '土曜日の0：05' => sub {
        my $t = localtime(Time::Piece->strptime('2014/1/4 00:05:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_end, undef);
        restore_time();
    };
};

subtest 'is_last_end_of_year' => sub {
    my $gouhou = Gouhou->new(+{
        consumer_key        => 'consumer_key',
        consumer_secret     => 'consumer_secret',
        access_token        => 'access_token',
        access_token_secret => 'access_token_secret',
    });
    subtest '最後の金曜日' => sub {
        my $t = localtime(Time::Piece->strptime('2014/12/25 00:00:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_last_end_of_year, 1);
        restore_time();
    };
    subtest '普通の金曜日' => sub {
        my $t = localtime(Time::Piece->strptime('2015/1/1 00:00:00', '%Y/%m/%d %H:%M:%S'));
        set_fixed_time($t->epoch);
        is($gouhou->is_last_end_of_year, undef);
        restore_time();
    };
};

subtest 'update_twitter' => sub {
    subtest 'HTTPでAPI実行' => sub {
        my $config = Config::Pit::get("GouhouAOuth");
        $config->{ssl} = 0;
        my $gouhou = Gouhou->new($config);
        eval {
            # 同じリクエストすると403になるので、乱数付ける
            my $test_name = 'itochin_:' . int(rand(100));
            $gouhou->update_twitter({
                name => $test_name,
            });
        };
        ok($@);
        isa_ok($@, "Net::Twitter::Error");
        is($@->code, 403);
    };
    subtest 'HTTPSでAPI実行' => sub {
        my $config = Config::Pit::get("GouhouAOuth");
        my $gouhou = Gouhou->new($config);

        # 同じリクエストすると403になるので、乱数付ける
        my $test_name = 'itochin_:' . int(rand(100));
        $gouhou->update_twitter({
            name => $test_name,
        });
        ok(!$@);
    };
    subtest 'HTTPSでAPI実行' => sub {
        my $config = Config::Pit::get("GouhouAOuth");
        my $gouhou = Gouhou->new($config);

        # 名前を元に戻す
        my $test_name = 'itochin';
        $gouhou->update_twitter({
            name => $test_name,
        });
        ok(!$@);
    };
};
done_testing;

