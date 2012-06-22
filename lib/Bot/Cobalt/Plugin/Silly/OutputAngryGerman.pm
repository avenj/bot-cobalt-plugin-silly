package Bot::Cobalt::Plugin::Silly::OutputAngryGerman;
our $VERSION;
BEGIN {
  require Bot::Cobalt::Plugin::Silly;
  $VERSION = $Bot::Cobalt::Plugin::Silly::VERSION;
}

## borrowed from Acme::LAUTER::DEUTSCHER

use 5.12.1;

use Lingua::Translate;

use Bot::Cobalt::Common;

sub TRANS () { 0 }

sub new { bless [], shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  register( $self, 'USER',
    'message'
  );

  logger->info("$VERSION loaded");
  
  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;
  
  logger->info("Unloaded");
  
  PLUGIN_EAT_NONE
}

sub Outgoing_message {
  my ($self, $core) = splice @_, 0, 2;

  my $txt = ${$_[2]};

  return PLUGIN_EAT_NONE if $txt !~ /\w/;

  my $trans = $self->[TRANS] //= Lingua::Translate->new(
    src  => 'en',
    dest => 'de',
  );

  $txt = uc($trans->translate($txt));
  $txt =~ s/ (?<=\w) \. (?=\W|\Z) /!/gsx;

  ${$_[2]} = $txt;

  PLUGIN_EAT_NONE
}

1;
__END__
=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly::OutputAngryGerman - Output filter

=head1 SYNOPSIS

  !plugin load OutputGerman Bot::Cobalt::Plugin::Silly::OutputAngryGerman

=head1 DESCRIPTION

A L<Bot::Cobalt> plugin.

Makes your bot sound like a loud German fellow via L<Lingua::Translate>.

Conceptually borrowed from L<Acme::LAUTER::DEUTSCHER>.

(Pretty much guaranteed to make your bot's output dog-slow, too. Try to 
be nice to the translator services.)

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
