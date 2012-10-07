package DebMonWeb::Packages;
use Mojo::Base 'Mojolicious::Controller';

use Data::Serializer;

sub _loadpackagedata {
    my $self = shift;

    my $serializer = Data::Serializer->new(
        serializer => 'FreezeThaw',
        compress   => 1,
    );

    my $config = $self->stash('config');

    if (defined $config->{repodata} && -e $config->{repodata} ) {
        my $ref = $serializer->retrieve($config->{repodata});
    } else {
        die "Repodata not available or not configured";
    }
}

sub package {
    my $self = shift;

    $self->stash(packagedata => $self->_loadpackagedata);
    $self->render();
}

sub overview {
  my $self = shift;

  $self->stash(packagedata => $self->_loadpackagedata);
  $self->render(
    message => 'Welcome to the Mojolicious real-time web framework!');
}

1;
