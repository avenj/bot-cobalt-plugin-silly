package Bot::Cobalt::Plugin::Silly::DailyFail;
our $VERSION;
BEGIN {
  require Bot::Cobalt::Plugin::Silly;
  $VERSION = $Bot::Cobalt::Plugin::Silly::VERSION;
}

use 5.12.1;

use Acme::Daily::Fail qw/get_headline/;

use Bot::Cobalt::Common;

sub new { bless [], shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'SERVER',
    'public_cmd_headline', 'public_cmd_dailyfail'
  );
  
  $core->log->info("$VERSION loaded");

  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;

  $core->log->info("Unloaded");

  return PLUGIN_EAT_NONE
}

sub Bot_public_cmd_dailyfail { Bot_public_cmd_headline(@_) }
sub Bot_public_cmd_headline {
  my ($self, $core) = splice @_, 0, 2;

  my $msg     = ${ $_[0] };
  my $context = $msg->context;

  my $resp = get_headline();

  my $channel = $msg->channel;

  $core->send_event( 'send_message',
    $context,
    $channel,
    "BREAKING: ".$resp
  ) if $resp;
  
  return PLUGIN_EAT_ALL
}

1;
__END__
=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly::DailyFail - Get silly headlines

=head1 SYNOPSIS

  !plugin load DailyFail Bot::Cobalt::Plugin::Silly::DailyFail
  !headline
  !dailyfail

=head1 DESCRIPTION

A L<Bot::Cobalt> plugin.

Simple bridge to L<Acme::Daily::Fail>.

Produces random newspaper headlines.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
