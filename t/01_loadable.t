use Test::More tests => 24;

my @modules = qw/
  AutoOpAll
  DailyFail
  LOLCAT
  OutputLOLCAT
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
