requires 'perl'         => '5.18.0';
requires 'Net::Twitter' => '4.00006';
requires 'Config::Pit'  => '0.04';
requires 'Try::Tiny'    => '0.18';

on 'test' => sub {
    requires 'Test::More'     => '0.98';
    requires 'Test::MockTime' => '0.12';
};

