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
    $c->stash->{chain_end_called} ||= 0;
    $c->stash->{chain_end_called}++;
}

sub magic_side_request :Local{
    my( $self, $c, @rest_of_path ) = @_;
    $c->debug('magic side request happens!');

    $c->stash->{side_called} ||= 0;
    $c->stash->{side_called}++;

    my $path = '/'.join '/', @rest_of_path;

    $c->request->path($path);
    $c->dispatcher->prepare_action($c);

    $c->go($c->action, $c->request->args,  $c->request->captures);
}

sub root : Chained('/') PathPart('') CaptureArgs(0) {
    my( $self, $c, $arg ) = @_;
    $c->stash->{root_called} ||= 0;
    $c->stash->{root_called}++;
}

sub foo : Chained('root') PathPart('foo2') CaptureArgs(1) {
    my( $self, $c, $arg ) = @_;
    $c->stash->{foo_called} ||= 0;
    $c->stash->{foo_called}++;
}

sub other_end : Chained('foo') PathPart('') Args(1) {
    my( $self, $c, $arg ) = @_;
    $c->stash->{other_called} ||= 0;
    $c->stash->{other_called}++;
}

1;
