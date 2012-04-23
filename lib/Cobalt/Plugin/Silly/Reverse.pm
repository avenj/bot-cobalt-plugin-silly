package Cobalt::Plugin::Silly::Reverse;
our $VERSION = '0.02';

use 5.10.1;
use strict;
use warnings;

use Object::Pluggable::Constants qw/ :ALL /;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'SERVER',
    [ 'public_cmd_reverse' ]  
  );
  
  $core->log->info("$VERSION loaded");
  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;
  $core->log->info("Unloaded");
  return PLUGIN_EAT_NONE
}

sub Bot_public_cmd_reverse {
  my ($self, $core) = splice @_, 0, 2;

  my $msg     = ${ $_[0] };
  my $context = $msg->context;

  my $str = join ' ', @{ $msg->message_array };
  my $reverse = scalar reverse $str;

  my $channel = $msg->channel;
  $core->send_event( 'send_message',
    $context,
    $channel,
    "reverse: ".$reverse
  );  
  
  return PLUGIN_EAT_ALL
}

1;
__END__
=pod

=head1 NAME

Cobalt::Plugin::Silly::Reverse

=head1 SYNOPSIS

  !plugin load Reverse Cobalt::Plugin::Silly::Reverse
  !reverse some string

=head1 DESCRIPTION

Reverse some text.

Why? Well, it's in Cobalt-Plugin-Silly, that's why.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
