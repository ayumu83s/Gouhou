# NAME

合法ラーメンの日bot

# SYNOPSIS

    plenvで環境作る
    perlは5.18を入れる

    plenv local 5.18
    plenv install-cpanm
    cpanm Carton

    モジュールインストール
    carton install

    ! Installing the dependencies failed: Module 'Net::SSLeay' is not installed
    とか怒られる時は、SSLの基本ライブラリを入れる
    $ sudo yum install openssl-devel zlib-devel readline-devel
    see http://blog.livedoor.jp/nemesis_00x/archives/18003783.html

    Twitterの認証をConfig::Pitで設定(config_oauth.plの中身を修正)
    carton exec -- perl ./script/config_oauth.pl
    
    cronで定期的に実行(実行パス修正）
    crontab etc/crontab

# DESCRIPTION

サクラのレンタルサーバーで動かしたくて作ったヤツ
木曜日に合法ラーメン開始をアナウンス
金曜日に終了をお知らせするボット

# LICENSE

Copyright (C) ayumu83s.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ayumu83s <ayumu.itou.1125@gmail>
