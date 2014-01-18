#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Config::Pit;
use Gouhou;
use FindBin;
use File::Spec;
use Try::Tiny;
use Time::Piece;
use Carp qw(cloak);

my $base_dir = "$FindBin::Bin/..";

my $gouhou_icon = File::Spec->catfile($base_dir, 'res', 'ramen.png');
my $normal_icon = File::Spec->catfile($base_dir, 'res', 'normal.png');

# ~/.pit/配下にyamlがある
my $config = Config::Pit::get("GouhouAOuth");
my $gouhou = Gouhou->new($config);
my $now = localtime->strftime('%Y-%m-%d %H:%M:%S');

try {
    if ($gouhou->is_start) {
        $gouhou->update_twitter({
            name        => 'itochin@今日はラーメンの日',
            prof_image  => $gouhou_icon,
            tweet       => '本日は合法ラーメンの日です！！',
        });
        print "[" . $now . "]" . "gouhou is start success!!";
    }
    elsif ($gouhou->is_end) {
        my $tweet = '合法ラーメンの日は終了しました。また来週までさようなら。';
    
        # 1年の最後ならメッセージを変える
        if ($gouhou->is_last_end_of_year) {
            $tweet =  '本年度の合法ラーメンは全て終了しました。また来年までさようなら。';
        }
        $gouhou->update_twitter({
            name        => 'itochin',
            prof_image  => $normal_icon,
            tweet       => $tweet,
        });
        print "[" . $now . "]" . "gouhou is end success!!";
    }
catch {
    cloak $_;
}

