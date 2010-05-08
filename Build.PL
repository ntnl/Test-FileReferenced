#!/usr/bin/perl
# Copyright 2010, Bartłomiej Syguła (natanael@natanael.krakow.pl)
#
# This is free software. It is licensed, and can be distributed under the same terms as Perl itself.
#
# For more, see my website: http://natanael.krakow.pl/
use strict; use warnings;

use Module::Build;
my $build = Module::Build->new (
    # Who I am :)
    module_name => 'Test::Referenced',
    license     => 'perl',

    dist_abstract => 'Test subroutine output against reference data stored in file(s).',
    dist_author   => 'Bartłomiej Syguła <natanael@natanael.krakow.pl>',

    # What You must have, and what will do You good.
    requires => {
        'perl' => '5.8.0',

        'Test::More'         => '0.94',
        'Carp::Assert::More' => '1.12',
        'FindBin'            => '1.47',
        'YAML::Syck'         => '1.05',
    },
#    recommends => {
#        'Devel::Cover' => '0.64',
#    },

    # Play nice with friends ;)
    create_makefile_pl => 'traditional',
    create_packlist    => 1,
    create_readme      => 1,
    dynamic_config     => 0, # No dynamics needed, as of now.
);

$build->create_build_script;

# vim: fdm=marker
