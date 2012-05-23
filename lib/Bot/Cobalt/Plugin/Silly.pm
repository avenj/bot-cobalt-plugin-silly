package Bot::Cobalt::Plugin::Silly;
our $VERSION = '0.001';

sub new { die __PACKAGE__." is just a placeholder. See POD." }

1;
__END__

=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly - Silly Bot::Cobalt plugins

=head1 DESCRIPTION

A collection of completely silly L<Bot::Cobalt> plugins; these can be 
add to your C<plugins.conf> to do very useless stuff.

=over

=item *

L<Bot::Cobalt::Plugin::Silly::AutoOpAll>
AutoOp *all* users that join a channel.

=item *

L<Bot::Cobalt::Plugin::Silly::DailyFail>
Enlightening newspaper headlines; bridges L<Acme::Daily::Fail>

=item *

L<Bot::Cobalt::Plugin::Silly::LOLCAT>
Bridge <POE::Filter::LOLCAT> to translate text into LOLCAT

=item *

L<Bot::Cobalt::Plugin::Silly::OutputLOLCAT> 
LOLCAT-enabled bot output filter

=item *

L<Bot::Cobalt::Plugin::Silly::OutputAngryGerman>
Loud German output filter (similar to L<Acme::LAUTER::DEUTSCHER>)

=item *

L<Bot::Cobalt::Plugin::Silly::OutputLeet>
Leetspeak output filter (bridges L<Acme::LeetSpeak>)

=item *

L<Bot::Cobalt::Plugin::Silly::MstOMatic>
Get Matt S. Trout rants on demand. (In appreciation for bringing us 
L<Moo>, of course)

=item *

L<Bot::Cobalt::Plugin::Silly::Reverse>
Reverse a string.

=item *

L<Bot::Cobalt::Plugin::Silly::Rot13>
Rot13 a string.

=item *

L<Bot::Cobalt::Plugin::Silly::ThreatLevel>
Get the current DHS terror alert level, so you know when to duct tape 
your house shut.

=back

=head1 CONTRIBUTING

I'd be happy to review contributed Silly plugins to potentially add 
more uselessness to this distribution.

Send them off to <avenj@cobaltirc.org>, please.

The only real requirement is that they not do much of anything anyone 
might find productive.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
