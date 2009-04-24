package MyApp;

use strict;
use warnings;
use Catalyst qw<
                   -Debug
               >;

__PACKAGE__->config(
    name                  => 'MyApp',
);

__PACKAGE__->setup;


sub chain :Chained('/') PathPart('foo') CaptureArgs(1){
    my( $self, $c, $arg ) = @_;
    $c->stash->{chain_called} ||= 0;
    $c->stash->{chain_called}++;
    $c->log->debug('chain action happens: ', $arg);
}

sub end_of_chain : Chained('chain') PathPart('bar') Args(0){
    my( $self, $c ) = @_;
    $c->log->debug('end of chain action happens!');
}

sub magic_side_request :Local{
    my( $self, $c, @rest_of_path ) = @_;
    $c->debug('magic side request happens!');

    my $path = '/'.join '/', @rest_of_path;

    $c->request->path($path);
    $c->dispatcher->prepare_action($c);

    $c->go($c->action, $c->request->args,  $c->request->captures);
}

;1;
