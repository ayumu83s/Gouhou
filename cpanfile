requires 'perl'         => '5.18.0';
requires 'Net::Twitter' => '4.00006';

on 'test' => sub {
    requires 'Test::More'     => '0.98';
    requires 'Test::MockTime' => '0.12';
};

