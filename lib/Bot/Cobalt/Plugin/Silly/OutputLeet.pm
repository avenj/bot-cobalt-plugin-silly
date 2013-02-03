package Bot::Cobalt::Plugin::Silly::OutputLeet;

use 5.12.1;

use Acme::LeetSpeak;

use Bot::Cobalt::Common;

sub new { bless [], shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'USER',
    'message'
  );

  $core->log->info("Loaded");
  
  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->log->info("Unloaded");
  
  PLUGIN_EAT_NONE
}

sub Outgoing_message {
  my ($self, $core) = splice @_, 0, 2;

  ${$_[2]} = leet(${$_[2]});

  PLUGIN_EAT_NONE
}

1;
__END__
=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly::OutputLeet

=head1 SYNOPSIS

  !plugin load OutputLeet Bot::Cobalt::Plugin::Silly::OutputLeet

=head1 DESCRIPTION

A L<Bot::Cobalt> plugin.

Turns all of your bot's message output into l33tspeak.

Uses L<Acme::LeetSpeak>.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
