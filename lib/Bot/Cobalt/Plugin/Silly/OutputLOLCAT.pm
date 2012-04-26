package Bot::Cobalt::Plugin::Silly::OutputLOLCAT;
our $VERSION = '0.02';

use 5.10.1;

use POE::Filter::Stackable;
use POE::Filter::Line;
use POE::Filter::LOLCAT;

use Bot::Cobalt::Common;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'USER',
    [ 'message' ]  
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

sub Outgoing_message {
  my ($self, $core) = splice @_, 0, 2;

  my $filter = $self->{Filter};
  $filter->get_one_start([${$_[2]}."\n"]);
  my $lol = $filter->get_one;
  my $cat = shift @$lol;
  chomp($cat);
  ${$_[2]} = $cat;

  return PLUGIN_EAT_NONE
}

1;
__END__
=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly::OutputLOLCAT

=head1 SYNOPSIS

  !plugin load OutputLOLCAT Bot::Cobalt::Plugin::Silly::OutputLOLCAT

=head1 DESCRIPTION

Turns all of your bot's message output into lolcats.

Probably not a great idea, but it's Plugin::Silly.

A simple bridge to L<POE::Filter::LOLCAT> (which in turn uses 
L<Acme::LOLCAT>).

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
