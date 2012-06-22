package Bot::Cobalt::Plugin::Silly::MstOMatic;
our $VERSION;
BEGIN {
  require Bot::Cobalt::Plugin::Silly;
  $VERSION = $Bot::Cobalt::Plugin::Silly::VERSION;
}

use 5.12.1;

use Bot::Cobalt;
use Bot::Cobalt::Common;

use URI::Escape;
use HTTP::Request;

sub new { bless [], shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;

  register( $self, 'SERVER',
    'public_cmd_mst',
    'public_cmd_mstomatic',
    'mstomatic_resp_recv',
  );
  
  logger->info("$VERSION loaded");

  PLUGIN_EAT_NONE 
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;
  
  logger->info("Unloaded");
  
  PLUGIN_EAT_NONE
}

sub Bot_public_cmd_mstomatic { Bot_public_cmd_mst(@_) }
sub Bot_public_cmd_mst {
  my ($self, $core) = splice @_, 0, 2;
  my $msg     = ${ $_[0] };

  my $context = $msg->context;
  my $channel = $msg->channel;
  
  $self->_request_mst( $context, $channel);
  
  PLUGIN_EAT_ALL
}


sub Bot_mstomatic_resp_recv {
  my ($self, $core) = splice @_, 0, 2;
  my $response = ${ $_[1] };
  my $args     = ${ $_[2] };
  my ($context, $channel) = @$args;
  
  unless ($response->is_success) {
    broadcast( 'send_message', $context, $channel,
      "HTTP failed: ".$response->code
    );
    return PLUGIN_EAT_ALL
  }

  my $mst_rant;
  my $content = $response->content;
  if ( $content =~ /<h1><a.*>(.*)<\/a><\/h1>/i ) {
    $mst_rant = "MST: $1";
  } else {
    $mst_rant = "Unable to parse a mst rant!";
  }
  
  broadcast( 'send_message', $context, $channel,
    $mst_rant
  );
  
  return PLUGIN_EAT_ALL
}

sub _request_mst {
  my ($self, $context, $channel) = @_;

  my $uri = 'http://www.trout.me.uk/cgi-bin/mstomatic.cgi';
  
  if (core()->Provided->{www_request}) {
    my $req = HTTP::Request->new( 'GET', $uri ) || return undef;

    broadcast( 'www_request',
      $req,
      'mstomatic_resp_recv',
      [ $context, $channel ],
    );
  } else {
    broadcast( 'send_message',
      $context, $channel,
      "No async HTTP found, try loading Bot::Cobalt::Plugin::WWW"
    );
  }
}

1;
__END__

=pod

=head1 NAME

Bot::Cobalt::Plugin::Extras::MstOMatic - Matt S. Trout ranting on demand.

=head1 USAGE

  !mst
  !mstomatic

=head1 DESCRIPTION

A L<Bot::Cobalt> plugin.

Uses L<http://www.trout.me.uk/cgi-bin/mstomatic.cgi> to deliver Matthew S. 
Trout rants whenever you might need them.

... MST can feel free to slap me.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
