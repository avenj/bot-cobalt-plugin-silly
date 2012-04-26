package Bot::Cobalt::Plugin::Silly;
our $VERSION = '0.102';

sub new { die __PACKAGE__" is just a placeholder." }

1;
__END__

=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly - Silly Cobalt2 plugins

=head1 INCLUDED

A collection of silly plugins:

=over


=item *

L<Bot::Cobalt::Plugin::Silly::AutoOpAll>
AutoOp all users that join a channel.

=item *

L<Bot::Cobalt::Plugin::Silly::DailyFail>
Bridge L<Acme::Daily::Fal>

=item *

L<Bot::Cobalt::Plugin::Silly::LOLCAT>
Bridge <POE::Filter::LOLCAT>

=item *

L<Bot::Cobalt::Plugin::Silly::OutputLOLCAT> 
LOLCAT-enabled output filter

=item *

L<Bot::Cobalt::Plugin::Silly::OutputAngryGerman>
Loud German output filter

=item *

L<Bot::Cobalt::Plugin::Silly::OutputLeet>
Leetspeak output filter

=item *

L<Bot::Cobalt::Plugin::Silly::MstOMatic>
Get Matt S. Trout rants on demand.

=item *

L<Bot::Cobalt::Plugin::Silly::Reverse>
Reverse text.

=item *

L<Bot::Cobalt::Plugin::Silly::Rot13>
Rot13 text.

=item *

L<Bot::Cobalt::Plugin::Silly::ThreatLevel>
Get the current DHS terror alert level.


=back

=head1 CONTRIBUTING

I'd be happy to review contributed Silly plugins to potentially add to 
this distribution.

Send them off to <avenj@cobaltirc.org>, please.

The only real requirement is that they not be very useful at all.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

=cut
