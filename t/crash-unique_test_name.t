#!/usr/bin/perl

use strict; use warnings;

use Test::More tests => 3;
use Test::Exception;
use Test::FileReferenced;

# Check if Test::FileReferenced is able to detect,
# that a test name is not unique.

is_referenced_ok(
    {
        a => 'A',
        b => 'B',
    },
    "This will pass",
);

throws_ok {
    is_referenced_ok(
        {
            a => 'A',
            b => 'B',
        },
        "This will pass", # <-- not really, actually ;) 
    );
}  qr{is not unique}, "Doubled test name detected";

is_referenced_ok(
    {
        x => 'X',
        y => 'Y',
    },
    "This will pass, again",
);

# vim: fdm=marker
