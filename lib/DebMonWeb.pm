package DebMonWeb;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Router
  my $r = $self->routes;
  my $config = $self->plugin('Config', {file  => '/etc/debmonweb.conf'});
  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
