#!/usr/bin/perl

use MyApp;
use Catalyst::Test qw< MyApp >;
use Test::More tests => 4;

my( $res, $c ) = ctx_request( '/foo/x/bar' );

is( $c->stash->{chain_called}, 1, 'called chain in sane fashion, chain should happen once' );

is( $c->stash->{chain_end_called}, 1, 'called chain end in sane fashion, chain should happen once' );

my( $res, $c ) = ctx_request( '/magic_side_request/foo/x/bar' );

is( $c->stash->{chain_called}, 1, 'called chain indirectly, chain should happen once' );
is( $c->stash->{chain_end_called}, 1, 'called chain end indirectly, chain should happen once' );





