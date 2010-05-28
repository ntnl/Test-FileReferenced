#!/usr/bin/perl

use strict; use warnings;

use FindBin qw( $Bin );
use Test::More tests => 1;

require Test::FileReferenced;

# Check if Test::FileReferenced displays correct prompt.

our @diag_output;

chdir $Bin .q{/../};
$ENV{'PATH'} = $Bin .q{/fake_bin},
chmod 0755, $Bin . q{/fake_bin/diff};
chmod 0755, $Bin . q{/fake_bin/kdiff};

Test::FileReferenced::is_referenced_in_file("Foo", 'example-hash', "Fake", sub { return; });

Test::FileReferenced::at_exit();

is_deeply(
    \@diag_output,
    [
        q{Resulting and reference files differ. To see differences run one of:},
        q{      diff t/example-hash-result.yaml t/example-hash.yaml},
        q{     kdiff t/example-hash-result.yaml t/example-hash.yaml},
        qq{\n},
        q{If the differences ware intended, reference data can be updated by running:},
        q{        mv t/example-hash-result.yaml t/example-hash.yaml},
    ],
    "Prompt OK"
);

# Overwrite 'diag':
package Test::More;

no warnings;
sub diag { # {{{
    return push @diag_output, @_;
} # }}}

# vim: fdm=marker
