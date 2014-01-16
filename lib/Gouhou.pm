package Gouhou;
use 5.018;
use strict;
use warnings;
use Time::Piece;
use Net::Twitter;

use Data::Dumper;
use Time::Seconds qw(ONE_DAY);
our $VERSION = "0.01";

sub new {
    my ($class, $args) = @_;
    my $self = {
        net => Net::Twitter->new(
            traits              => [qw/API::RESTv1_1/],
            consumer_key        => $args->{consumer_key},
            consumer_secret     => $args->{consumer_secret},
            access_token        => $args->{access_token},
            access_token_secret => $args->{access_token_secret},
            # HTTPSでAPI実行しないと、2014/1/15から403が返る
            ssl                 => $args->{ssl} //=1,
        ),
        start => {
            wdayname => $args->{start}->{wdayname} //= 'Thu',
            hour     => $args->{start}->{hour}     //= 0,
            min      => $args->{start}->{min}      //= 5,
        },
        end => {
            wdayname => $args->{end}->{wdayname}   //= 'Fri',
            hour     => $args->{end}->{hour}       //= 0,
            min      => $args->{end}->{min}        //= 5,
        },
    };
    return bless $self, $class;
}

# 合法開始のアナウンスするかチェックする
sub is_start {
    my $self = shift;
    my $now = localtime;
    
    # 木曜日の0:05かチェック
    my $check = $self->{start};
    return if ($now->wdayname ne $check->{wdayname});
    return if (($now->hour != $check->{hour}) || ($now->min != $check->{min}));

    return 1;
}

# 合法終了のアナウンスするかチェックする
sub is_end {
    my $self = shift;
    my $now = localtime;

    # 金曜日の0:05かチェック
    my $check = $self->{end};
    return if ($now->wdayname ne $check->{wdayname});
    return if (($now->hour != $check->{hour}) || ($now->min != $check->{min}));

    return 1;
}

# 1年最後の合法終了かチェックする
sub is_last_end_of_year {
    my $self = shift;
    my $now = localtime;

    # 次の週の年が大きくなってたら最後だと判断
    my $next_end = localtime($now + (ONE_DAY * 7));
    return unless ($next_end->year > $now->year);
    return 1;
}

# つぶやきと画像の更新
sub update_twitter {
    my $self = shift;
    my $args = shift;
    
    # 名前を更新
    if ($args->{name}) {
        $self->{net}->update_profile({
            name => $args->{name},
        });
    }

    # プロフィールアイコン更新
    if ($args->{prof_image}) {
        $self->{net}->update_profile_image([
            $args->{prof_image},
        ]);
    }

    # つぶやく
    if ($args->{tweet}) {
        $self->{net}->update($args->{tweet});
    }
    return;
}

1;
__END__

=encoding utf-8

=head1 NAME

Gouhou - It's new $module

=head1 SYNOPSIS

    use Gouhou;
    my $gouhou = Gouhou->new({
        consumer_key        => 'consumer_key',
        consumer_secret     => 'consumer_secret',
        access_token        => 'access_token',
        access_token_secret => 'access_token_secret',
    });
    $gouhou->update_twitter({
        name        => 'itochin@今日はラーメンの日',
        prof_image  => '/res/xxxx.png',
        tweet       => '本日は合法ラーメンの日です！！',
    });

=head1 DESCRIPTION

Gouhou is ...

=head1 LICENSE

Copyright (C) ayumu83s.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ayumu83s E<lt>ayumu.itou.1125@gmailE<gt>

=cut

