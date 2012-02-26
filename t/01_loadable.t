use Test::More tests => 21;

my @modules = qw/
  AutoOpAll
  DailyFail
  LOLCAT
  MstOMatic
  Reverse
  Rot13
  ThreatLevel
/;

my $prefix = "Cobalt::Plugin::Silly::";

for my $mod (@modules) {
  my $module = $prefix.$mod;
  use_ok( $module );
  new_ok( $module );
  can_ok( $module, 'Cobalt_register', 'Cobalt_unregister' );
}
