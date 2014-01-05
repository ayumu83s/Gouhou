package Gouhou;
use 5.018;
use strict;
use warnings;
use Time::Piece;
use Net::Twitter;

our $VERSION = "0.01";

sub new {
    my $class = shift;
    my %args = @_;
    my $self = +{
        net => Net::Twitter->new(
            traits              => [qw/API::RESTv1_1/],
            consumer_key        => $args{consumer_key},
            consumer_secret     => $args{consumer_secret},
            access_token        => $args{access_token},
            access_token_secret => $args{access_token_secret},
        ),
    };
    return bless $self, $class;
}

# つぶやきと画像の更新
sub update_twitter {
    my $self = shift;
    my $now = localtime;
    
    # 0:05かチェック
    if ($now->hour == 0 && $now->min == 5) {
        # 木曜日ならば合法日
        if ($now->wdayname eq 'Thu') {
            # 名前を更新
            $self->{net}->update_profile({
                name => 'itochin@今日はラーメンの日',
            });
            $self->{net}->update_profile_image([
                "/Users/itochin/work/dev/perl/gouhou_ramen/ramen.png",
            ]);
            $self->{net}->update("本日は合法ラーメンの日です！！");
        }
        # 金曜日ならば合法終了
        elsif ($now->wdayname eq 'Fri') {
            # 名前を更新
            $self->{net}->update_profile({
                name => 'itochin',
            });
            $self->{net}->update_profile_image([
                "/Users/itochin/work/dev/perl/gouhou_ramen/normal.png",
            ]);
            $self->{net}->update("合法ラーメンの日は終了しました。また来週までさようなら。");
        }
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Gouhou - It's new $module

=head1 SYNOPSIS

    use Gouhou;
    my $gouhou = Gouhou->new(
        consumer_key        => 'consumer_key',
        consumer_secret     => 'consumer_secret',
        access_token        => 'access_token',
        access_token_secret => 'access_token_secret',
    );
    $gouhou->update_twitter;

=head1 DESCRIPTION

Gouhou is ...

=head1 LICENSE

Copyright (C) ayumu83s.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ayumu83s E<lt>ayumu.itou.1125@gmailE<gt>

=cut

