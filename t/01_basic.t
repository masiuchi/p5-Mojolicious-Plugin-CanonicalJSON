use Mojo::Base -strict;

use Test::More;
use Mojolicious::Lite;
use Test::Mojo;

use JSON;
use File::Basename;
use File::Spec;

# Use META.json as test data.
my $dir = dirname( dirname(__FILE__) );
my $json_file = File::Spec->catfile( $dir, 'META.json' );
open my $fh, '<', $json_file;
my $json_text = join '', <$fh>;
close $fh;
my $hash = from_json($json_text);

plugin 'CanonicalJSON';

get '/' => sub {
    my $c = shift;
    $c->render( json => $hash );
};

my $t = Test::Mojo->new;
$t->get_ok('/')->status_is(200)
    ->content_is( to_json( $hash, { canonical => 1, escape_slash => 1 } ) );

done_testing();

