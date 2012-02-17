package Cobalt::Plugin::Silly::LOLCAT;
our $VERSION = '0.01';

use POE::Filter::Stackable;
use POE::Filter::Line;
use POE::Filter::LOLCAT;

use Cobalt::Common;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'SERVER',
    [ 'public_cmd_lolcat' ]  
  );

  $self->{Filter} = POE::Filter::Stackable->new(
    Filters => [
      POE::Filter::Line->new(),
      POE::Filter::LOLCAT->new(),
    ],
  );
  
  $core->log->info("$VERSION loaded");
  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;
  $core->log->info("Unloaded");
  return PLUGIN_EAT_NONE
}

sub Bot_public_cmd_lolcat {
  my ($self, $core) = splice @_, 0, 2;

  my $context = ${ $_[0] };
  my $msg     = ${ $_[1] };

  my $str = decode_irc( $msg->{message} );
  $str ||= "No string to handle";

  my $filter = $self->{Filter};
  $filter->get_one_start([$str."\n"]);
  my $lol = $filter->get_one;
  my $cat = shift @$lol;
  chomp($cat);

  my $channel = $msg->{channel};
  $core->send_event( 'send_message',
    $context,
    $channel,
    $cat
  ) if $cat;  
  
  return PLUGIN_EAT_ALL
}

1;
__END__
