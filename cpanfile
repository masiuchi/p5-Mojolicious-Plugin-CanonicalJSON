requires 'Mojolicious';
requires 'Tie::IxHash';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'JSON';
    requires 'File::Basename';
    requires 'File::Spec';
};

