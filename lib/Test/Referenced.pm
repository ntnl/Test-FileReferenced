# Copyright 2010, Bartłomiej Syguła (natanael@natanael.krakow.pl)
#
# This is free software. It is licensed, and can be distributed under the same terms as Perl itself.
#
# For more, see my website: http://natanael.krakow.pl/

package Test::Referenced;

=encoding UTF-8

=head1 NAME

Test::Referenced - Test against reference data stored in file(s).

=head1 SYNOPSIS

 use Test::Referenced;
 
 Test::Referenced::set_serializer('mydump', \&My::Dumper::Load, \&My::Dumper::Dump);
 
 is_referenced_ok( complex_data_structure(), "complex data structure" );
 
 is_referenced_in_file ( data_structure(), "data structure", "data_structure" );
 
 Test::Referenced::at_exit();

=head1 DESCRIPTION

Test::Referenced helps testing routines returning complex data structures.
This is achieved by serializing test's output (by default using YAML::Syck),
and allowing the Developer to compare it with reference data.

In case there are differences between reference and actual result,
comparizon can be made using traditional UNIX diff-like (diff, vimdiff, gvimdiff, kdiff) utilities.

In such case, Test::Referenced - after the test completes - will ask the Developer to run diff on result and reference data.
If all differences ware intended, Developer may just replace reference data with actual test results.

=head1 REFERENCE FILES

Reference files are data dumps using - by default - YAML::Syck.

=over

=item Default reference file

Default reference file contains data for C<is_referenced_ok> tests.
Each test has it's own key in the file. For the following example test:

 is_referenced_ok(\%ENV, 'env');
 is_referenced_ok(\@INC, 'inc');

...we have the following reference file:

 ---
 env:
   LANG: pl_PL
   LANGUAGE: pl_PL
   LC_ALL: pl_PL.UTF-8
 inc:
   /usr/lib/perl5/site_perl
   /usr/lib/perl5/vendor_perl/5.10.1
   /usr/lib/perl5/vendor_perl
   /usr/lib/perl5/5.10.1

Name for the reference file is based on the tests's filename, with I<.t> replaced with extension native to the used dumper.
Example: if default serializer (YAML::Syck) is used, F<foo/bar.t> will use F<foo/bar.yaml>.

=item Custom reference files

Custom reference files are used by C<is_referenced_in_file> function. Each file contains reference data
for single test case. For the following example test:

 is_referenced_in_file(\%ENV, 'env', 'environment');

...we have the following reference file, named F<environment.yaml>:

 ---
 LANG: pl_PL
 LANGUAGE: pl_PL
 LC_ALL: pl_PL.UTF-8

=back

=head1 TEST FAILURES

If there are differences between referenced, and actual data, at the end of the test prompt will be printed, similar to:

 Resulting and reference files differ. To see differences run one of:
       diff foo-results.yaml foo.yaml
   gvimdiff foo-results.yaml foo.yaml
 
 If the differences ware intended, reference data can be updated by running:
         mv foo-results.yaml foo.yaml

If there is no F<foo.yaml> yes (first test run, for example) then the message will be similar to:
 
 No reference file found. It'a a good idea to create one from scratch manually.
 To inspect current results run:
        cat foo-results.yaml

 If You trust Your test output, You can use it to initialize deference file, by running:
         mv foo-results.yaml foo.yaml

=head1 SUBROUTINES

=over

=item is_referenced_ok ( $data, $name )

Compare C<$data> with reference stored under key C<$name> in default reference file.

=item is_referenced_in_file ( $data, $name, $file_basename )

Compare C<$data> with reference stored in custom file: F<$file_basename.yaml> (assuming the serializer is YAML::Syck).

=item set_serializer ( $extension, $load_coderef, $dump_coderef )

Changes default serializing functions to ones provided by the User. C<$extension> must also be provided, so Test::Referenced can
automatically create the default reference file, if needed.

You do not need to use this function, if You are happy with YAML::Syck usage.

=item at_exit ()

If there ware failed tests, C<at_exit()> will dump results from the test in temporary file, and then prompt to inspect changes.

If there ware no failures, C<at_exit()> will check, if results file (from any previous run) exists, and if so - remove it.
Nothing will be printed in this case.

Normally this function does not need to be run explicitly, as Test::Referenced will run it from it's C<END {}> sections.

=cut

1;

__END__

=back

=head1 CAVEATS

Most caveats listed here will - most probably - apply to any other Test module.
They have been listed for convenience, as they have been been found to be the most common issues a Developer might run into, while using Test::Referenced.

=over

=item Random ordering

Note, that Test::Referenced does not sort the data. If Your data is returned in random order (order is not actually important),
You should use the following:

 is_referenced_ok( [ sort @randomly_ordered_data ], "Test 01" )

=item Date and/or time

Your reference data is 'frozen' as it is in given time point. If results contain some elements derived from date/time,
they will be different each time You run the test. This will most likely create false negative results.

=item Host-based data

If Your test data contains some host-related data (URLs), tests will pass on Your host, but will probably fail on other machines.

=back

=head1 SEE ALSO

Test::More
Test::Referenced::Framework

=head1 COPYRIGHT

Copyright 2010, Bartłomiej Syguła (natanael@natanael.krakow.pl)

This is free software. It is licensed, and can be distributed under the same terms as Perl itself.

For more, see my website: http://natanael.krakow.pl/

=cut

# vim: fdm=marker
