#!/usr/bin/perl

use strict; use warnings;

use FindBin qw( $Bin );
use Test::More tests => 2 + 2 + 1;
use Test::Exception;
use Test::FileReferenced;

# Check if Test::FileReferenced clears it's "-result" files.

$ENV{'FILE_REFERENCED_NO_PROMPT'} = 1;

# Create '-result' files, as if they ware left by previous run.
# Their content does not actually matter, they may remain empty as well.
my $fh;
open($fh, q{>}, $Bin.q{/feature-cleanup-result.yaml}) or die("Unable to write '-result' file!");
open($fh, q{>}, $Bin.q{/example-hash-result.yaml}) or die("Unable to write 'example-hash-result' file!");
print $fh "Just a test\n";

is_referenced_in_file(
    {
        bar => 'Bar',
        baz => 'Baz',
        foo => 'Foo',
    },
    'example-hash',
    "This will pass using example-hash file",
);

is (-f $Bin.q{/example-hash-result.yaml}, undef, "Unneded example-hash-result file was removed.");


is_referenced_ok(
    {
        a => 'A',
        b => 'B',
    },
    "This will pass",
);

# Actually, it's not a bad idea to call it explicitly, if You like :)
lives_ok {
    Test::FileReferenced::at_exit();
} 'at_exit runs file';

is (-f $Bin.q{/feature-cleanup-result.yaml}, undef, "Unneded -result file was removed.");

# vim: fdm=marker
