package DebMonWeb::Static;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub home {
  my $self = shift;

  $self->render(
    message => 'Welcome to the Mojolicious real-time web framework!');
}

1;
