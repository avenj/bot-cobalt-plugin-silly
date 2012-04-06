package Cobalt::Plugin::Silly::OutputAngryGerman;
our $VERSION = '0.01';

## borrowed from Acme::LAUTER::DEUTSCHER

use 5.12.1;

use Lingua::Translate;

use Cobalt::Common;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'USER',
    [ 'message' ]  
  );
  
  $self->{trans} = Lingua::Translate->new(
    src  => 'en',
    dest => 'de',
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

  my $txt = ${$_[2]};
  return PLUGIN_EAT_NONE if $txt !~ /\w/;
  $txt = uc($self->{trans}->translate($txt));
  $txt =~ s/ (?<=\w) \. (?=\W|\Z) /!/gsx;
  ${$_[2]} = $txt;

  return PLUGIN_EAT_NONE
}

1;
__END__
=pod

=head1 NAME

Cobalt::Plugin::Silly::OutputAngryGerman

=head1 SYNOPSIS

  !plugin load OutputGerman Cobalt::Plugin::Silly::OutputAngryGerman

=head1 DESCRIPTION

Makes your bot sound like a loud German fellow via L<Lingua::Translate>.

Conceptually borrowed from L<Acme::LAUTER::DEUTSCHER>.

Pretty much guaranteed to make your output slow.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut