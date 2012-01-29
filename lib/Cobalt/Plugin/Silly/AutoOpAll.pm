package Cobalt::Plugin::Silly::AutoOpAll;
our $VERSION = '0.01';

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
    [
      'user_joined',
      'public_cmd_aopall',
    ],
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
  my $context = ${ $_[0] };
  my $msg = ${ $_[1] };

  ## !aopall #chan
  ## !aopall -#chan

  my $nick = $msg->{src_nick};
  
  my $lev = $core->auth_level($context, $nick);
  return PLUGIN_EAT_ALL unless $lev >= 3;

  my $casemap = $core->Servers->{$context}->{CaseMap}
                // 'rfc1459';

  my $chan = $msg->{message_array}->[0];
  $chan = lc_irc($chan, $casemap);

  unless ( index($chan, '-') == 0 ) {
    $self->{AOPChans}->{$context}->{$chan} = 1;
    $core->send_event( 'send_notice',
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
  }
  
  return PLUGIN_EAT_ALL
}

sub Bot_user_joined {
  my ($self, $core) = splice @_, 0, 2;
  my $context = ${ $_[0] };
  my $joined  = ${ $_[1] };
  my $chan = $joined->{channel};
  my $nick = $joined->{src_nick};

  my $casemap = $core->Servers->{$context}->{CaseMap}
                // 'rfc1459';

  $chan = lc_irc($chan, $casemap);

  if ($chan ~~ [ keys %{ $self->{AOPChans} } ]) {
    $core->send_event( 'mode', $context, $chan, '+o '.$nick );
  }

  return PLUGIN_EAT_NONE
}

1;
