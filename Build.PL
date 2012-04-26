#!/usr/bin/env perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
  module_name => 'Bot::Cobalt::Plugin::Silly',
  dist_abstract => 'Silly Cobalt2 plugins',
  dist_author  => 'Jon Portnoy <avenj@cobaltirc.org>',

  license => 'perl',
  
  create_makefile_pl => 'small',
  
  create_readme => 1,
  
  requires => {
    'perl' => '5.12.1',

    'Bot::Cobalt::Core'       => 0,
    'Bot::Cobalt::Serializer' => 0,
    'Bot::Cobalt::Common'     => 0,
    
    'Lingua::Translate'  => 0,
    
    'Object::Pluggable::Constants' => 0,

    'POE::Filter::Stackable' => 0,
    'POE::Filter::Line'      => 0,
    'POE::Filter::LOLCAT'    => 0,    

    'Acme::Daily::Fail'  => 0,
    'Acme::LeetSpeak'    => 0,

    'XML::Simple' => 0,
  },
  
  recommends => {
  },
);

$build->create_build_script;
