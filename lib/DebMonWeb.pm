package DebMonWeb;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Router
  my $r = $self->routes;
  my $configfile = -e '/etc/debmonweb.conf' ? '/etc/debmonweb.conf' :
  'debmonweb.conf';

  my $config = $self->plugin('Config', {file  => $configfile});
  #my $piwik =  $self->plugin('Piwik');

  if ($config->{logfile}) {
    my $loglevel = $config->{loglevel} || 'info';
    $self->log( Mojo::Log->new(path => $config->{logfile}, level => $loglevel) );
  }

  # set passphrase if defined in configfile
  if ($config->{secret}) {
    $self->secrets([$config->{secret}]);
  }

  # Normal route to controller
  $r->get('/')->to('static#home')->name('home');
  $r->post('github')->to('github#process')->name('github');
  $r->get('/instructions')->to('static#instructions')->name('instructions');
  $r->get('icingadoc')->to('static#icingadoc')->name('icingadoc');
  $r->get('IcingaIdoutilsIcingaWebInstallation')->to('static#IcingaIdoutilsIcingaWebInstallation')->name('IcingaIdoutilsIcingaWebInstallation');
  $r->get('contributing')->to('static#contributing')->name('contributing');
  $r->get('mailinglists')->to('static#mailinglists')->name('mailinglists');

  $r->get('/packages')->to('packages#overview')->name('packageoverview');
  $r->get('/packages/:dist/:package')->to('packages#package')->name('package');
}
1;
