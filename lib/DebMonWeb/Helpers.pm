package DebMonWeb::Helpers;

use strict;
use warnings;

use List::MoreUtils;

use base 'Mojolicious::Plugin';

sub register {
    my ($self, $app) = @_;

    $app->helper(uniq => \&Liat::MoreUtils::uniq);
}


