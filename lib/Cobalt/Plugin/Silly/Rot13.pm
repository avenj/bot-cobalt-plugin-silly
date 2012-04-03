package Cobalt::Plugin::Silly::Rot13;
our $VERSION = '0.01';

use 5.12.1;
use strict;
use warnings;
use Object::Pluggable::Constants qw/ :ALL /;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'SERVER',
    [ 'public_cmd_rot13' ]  
  );
  
  $core->log->info("$VERSION loaded");
  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;
  $core->log->info("Unloaded");
  return PLUGIN_EAT_NONE
}

sub Bot_public_cmd_rot13 {
  my ($self, $core) = splice @_, 0, 2;

  my $context = ${ $_[0] };
  my $msg     = ${ $_[1] };

  my @message = @{$msg->{message_array}};
  my $str = join ' ', @message;

  $str =~ tr/a-zA-Z/n-za-mN-ZA-M/;

  my $channel = $msg->{channel};
  $core->send_event( 'send_message',
    $context,
    $channel,
    "rot13: ".$str
  );  
  
  return PLUGIN_EAT_ALL
}

1;
__END__
=pod

=head1 NAME

Cobalt::Plugin::Silly::Ro13

=head1 SYNOPSIS

  !plugin load Rot13 Cobalt::Plugin::Silly::Rot13
  !rot13 some text

=head1 DESCRIPTION

Rotate every character of a string 13 positions.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
