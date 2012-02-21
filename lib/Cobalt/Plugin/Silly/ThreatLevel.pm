package Cobalt::Plugin::Silly::ThreatLevel;
our $VERSION = '0.01';

use Cobalt::Common;

use URI::Escape;
use HTTP::Request;
use XML::Simple;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  $self->{core} = $core;
  $core->plugin_register( $self, 'SERVER',
    [
      'public_cmd_terrorism',
      'public_cmd_alertlevel',
      'terrorlev_resp_recv',
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

sub Bot_public_cmd_alertlevel { Bot_public_cmd_terrorism(@_) }
sub Bot_public_cmd_terrorism {
  my ($self, $core) = splice @_, 0, 2;
  my $context = ${ $_[0] };
  my $msg     = ${ $_[1] };
  
  my $channel = $msg->{channel};

  $self->_request( $context, $channel);
  
  return PLUGIN_EAT_ALL
}


sub Bot_terrorlev_resp_recv {
  my ($self, $core) = splice @_, 0, 2;
  my $response = ${ $_[1] };
  my $args     = ${ $_[2] };
  my ($context, $channel) = @$args;
  
  unless ($response->is_success) {
    $core->send_event( 'send_message', $context, $channel,
      "HTTP failed: ".$response->code
    );
    return PLUGIN_EAT_ALL
  }

  my $threat;
  my $content = $response->content;
  my $threatstr;
  my $xmlref = eval { XMLin($content) };
  if ($@) {
    $threatstr = "XML parsing error!";
  } else {
    my $threatlev = $xmlref->{CONDITION} // "XML parse error";
    $threatstr = "DHS terror threat level: $threatlev";
  }
  
  $core->send_event( 'send_message', $context, $channel,
    $threatstr
  );
  
  return PLUGIN_EAT_ALL
}

sub _request {
  my ($self, $context, $channel) = @_;
  my $core = $self->{core};

  my $uri = 'http://www.dhs.gov/dhspublic/getAdvisoryCondition';
  
  if ($core->Provided->{www_request}) {
    my $req = HTTP::Request->new( 'GET', $uri ) || return undef;
    $core->send_event( 'www_request',
      $req,
      'terrorlev_resp_recv',
      [ $context, $channel ],
    );
  } else {
    require LWP::UserAgent;
    my $ua = LWP::UserAgent->new(
      timeout => 3,
      max_redirect => 0,
      agent => 'cobalt2',
    );
    my $resp = $ua->get($uri);
    $core->send_event( 'terrorlev_resp_recv', 
      $resp->content || undef,
      $resp, 
      [ $context, $channel ] 
    );
  }
  return 1
}

1;
__END__

=pod

=head1 NAME

Cobalt::Plugin::Extras::ThreatLevel - get the DHS terrorism threat level

=head1 USAGE

  !terrorism

=head1 DESCRIPTION

Assists in advising as to when to duct tape your house shut.

Uses http://www.dhs.gov/dhspublic/getAdvisoryCondition

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
