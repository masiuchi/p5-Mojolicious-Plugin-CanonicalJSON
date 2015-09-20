package Mojolicious::Plugin::CanonicalJSON;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::JSON;
use Tie::IxHash;

our $VERSION = "0.01";

sub register {
    my ( $self, $app, $conf ) = @_;
    my $renderer       = $app->renderer;
    my $json_handler   = $renderer->handlers->{json};
    my $_encode_object = \&Mojo::JSON::_encode_object;
    $renderer->add_handler(
        json => sub {
            no warnings 'redefine';
            local *Mojo::JSON::_encode_object = sub {
                my $object = shift;
                use warnings;
                tie my %sorted_object, 'Tie::IxHash';
                $sorted_object{$_} = $object->{$_} for sort( keys %$object );
                $_encode_object->( \%sorted_object );
            };
            $json_handler->(@_);
        }
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

Mojolicious::Plugin::CanonicalJSON - Render JSON sorted by their keys.

=head1 SYNOPSIS

    # Mojolicious
    $app->plugin('CanonicalJSON');

    # Mojolicious::Lite
    plugin 'CanonicalJSON';

=head1 DESCRIPTION

Mojolicious::Plugin::CanonicalJSON is a Mojolicious plugins for rendering JSON sorted by their keys.

=head1 LICENSE

Copyright (C) Masahiro Iuchi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Masahiro Iuchi E<lt>masahiro.iuchi@gmail.comE<gt>

=cut

