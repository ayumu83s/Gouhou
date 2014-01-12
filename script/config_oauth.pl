#!/usr/bin/env perl

use strict;
use warnings;
use Config::Pit;

# Twitterの認証情報。適宜修正
Config::Pit::set("GouhouAOuth", data => +{
    access_token        => 'xxx',
    access_token_secret => 'xxx',
    consumer_key        => 'xxx',
    consumer_secret     => 'xxx',
});

