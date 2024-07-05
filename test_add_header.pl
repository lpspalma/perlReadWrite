#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);
use Text::CSV;

# Function to run the script
sub run_script {
    my ($input_file, $output_file) = @_;
    system("perl read_write.pl -i $input_file -o $output_file");
}

# Create a temp input file with complete rows
my ($input_fh, $input_filename) = tempfile();
print $input_fh "1,2,3\n4,5,6\n7,8,9\n";
close $input_fh;

# Create a temp output file
my ($output_fh, $output_filename) = tempfile();
close $output_fh;

# Run
run_script($input_filename, $output_filename);

# Check if the output file content
open my $out_fh, '<', $output_filename or die "Could not open '$output_filename' $!\n";
my @lines = <$out_fh>;
close $out_fh;

# Expected output
my @expected = (
    "column0,column1,column2\n",
    "1,2,3\n",
    "4,5,6\n",
    "7,8,9\n"
);

is_deeply(\@lines, \@expected, 'CSV file has correct headers and content');

# Negative test case: Create a temp input file with missing values
($input_fh, $input_filename) = tempfile();
print $input_fh "1,2\n4,5,6\n7,8\n";
close $input_fh;

# Create a temp output file for the negative case
($output_fh, $output_filename) = tempfile();
close $output_fh;

# Run
run_script($input_filename, $output_filename);

# Check if the output file has the expected content for the negative case
open $out_fh, '<', $output_filename or die "Could not open '$output_filename' $!\n";
@lines = <$out_fh>;
close $out_fh;

# Expected output for the negative case
my @expected_negative = (
    "column0,column1,column2\n",
    "1,2,\n",
    "4,5,6\n",
    "7,8,\n"
);

is_deeply(\@lines, \@expected_negative, 'CSV file with missing values is handled correctly');

done_testing();
