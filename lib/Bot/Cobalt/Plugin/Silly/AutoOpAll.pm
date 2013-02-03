package Bot::Cobalt::Plugin::Silly::AutoOpAll;

use 5.12.1;
use strict;
use warnings;

use Object::Pluggable::Constants qw/ :ALL /;

use IRC::Utils qw/lc_irc/;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  $self->{AOPChans} = {};

  $core->plugin_register( $self, 'SERVER',
      'user_joined',
      'public_cmd_aopall',
  );

  $core->log->info("Loaded");

  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;

  $core->log->info("Unloaded");

  return PLUGIN_EAT_NONE
}


sub Bot_public_cmd_aopall {
  my ($self, $core) = splice @_, 0, 2;
  my $msg = ${ $_[0] };
  my $context = $msg->context;

  ## !aopall #chan
  ## !aopall -#chan

  my $nick = $msg->src_nick;
  
  my $lev = $core->auth->level($context, $nick);
  return PLUGIN_EAT_ALL unless $lev >= 3;

  my $casemap = $core->Servers->{$context}->{CaseMap}
                // 'rfc1459';

  my $chan = $msg->message_array->[0];
  $chan = lc_irc($chan, $casemap);

  unless ( index($chan, '-') == 0 ) {
    $self->{AOPChans}->{$context}->{$chan} = 1;
    $core->send_event( 'notice',
      $context,
      $nick,
      "AutoOpping all on $chan",
    );
  } else {
    $chan = substr($chan, 1);

    my $resp;
    if (delete $self->{AOPChans}->{$context}->{$chan}) {
      $resp = "Not autoopping on $chan";
    } else {
      $resp = "No such chan ($chan) found";
    }

    $core->send_event( 'notice',
      $context,
      $nick,
      $resp
    );
  }
  
  return PLUGIN_EAT_ALL
}

sub Bot_user_joined {
  my ($self, $core) = splice @_, 0, 2;
  my $joined  = ${ $_[0] };

  my $context = $joined->context;

  my $chan = $joined->channel;
  my $nick = $joined->src_nick;

  my $casemap = $core->get_irc_casemap($context) || 'rfc1459' ;

  $chan = lc_irc($chan, $casemap);

  if (grep { $_ eq $chan } keys %{ $self->{AOPChans}->{$context} }) {
    $core->send_event( 'mode', $context, $chan, '+o '.$nick );
  }

  return PLUGIN_EAT_NONE
}

1;
__END__

=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly::AutoOpAll - AutoOp everyone

=head1 SYNOPSIS

  !plugin load AOPAll Bot::Cobalt::Plugin::Silly::AutoOpAll
  !aopall #mychan

The !aopall command equires at least access level 3.

=head1 DESCRIPTION

A L<Bot::Cobalt> plugin.

Totally silly plugin to automatically op every user joining a channel 
specified via '!aopall' (assuming the bot is opped, of course).

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
