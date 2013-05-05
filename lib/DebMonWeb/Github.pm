package DebMonWeb::Github;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
use Mojo::Home;
use Proc::Reliable;

sub process {
  my $self = shift;

  my $payload_json = $self->param('payload');
  warn $payload_json;

  my $json  = Mojo::JSON->new;
  my $payload  = $json->decode($payload_json);
  if ($json->error) {
      $self->app->log->debug('Could not decode payload: ' . $json->error);
      $self->render(text => 'Could not decode payload: ' . $json->error);
  } else {
      my $output = $self->_process_json ( $payload );
      $self->render(text => "triggered hook, output: $output");
  }
}

sub _process_json {
    my $self = shift;
    my $data = shift;

    my $config = $self->stash('config');

    my $event;

    if ($data->{commits}) {
        $event = 'commit';
    } elsif ($data->{ref} =~ /\/tags\//) {
        $event = 'tag';
    } elsif ($data->{action} && $data->{issue}) {
        $event = 'issue'; #just to be complete
    } elsif ($data->{action} && $data->{pull_request}) {
        $event = 'pull-request'; #just to be complete
    }
    $self->app->log->info("Received event \"$event\"");
    my $home = Mojo::Home->new;
    my $homedir = $home->detect;

    if ($config->{github_events} =~ /$event/) {
        my $p = Proc::Reliable->new();
        if ( $config->{github_command} ) {
            my $output = '';
            foreach my $cmd ( @{ $config->{github_command} } ) {

                $p->want_single_list(1);
                $output .= $p->run("cd $homedir/../; " .
                    $config->{github_command}) . "\n";
                $self->app->log->info("github command triggered: $output");
            }
            return $output;
        } else {
            $self->app->log->error("No github command defined");
            return "No github command defined";
        }
    }
}

1;
