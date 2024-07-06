#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use File::Temp qw(tempfile);
use lib '.';  # Ensure the test script can find the modules
use CSVProcessor qw(read_csv_data write_output);

# Plan the number of tests
plan tests => 12;

sub write_temp_csv {
    my ($content) = @_;
    my ($fh, $filename) = tempfile();
    print $fh $content;
    close $fh;
    return $filename;
}

# Positive scenario: Normal CSV data
{
    my $csv_content = "1,2,3\n4,5,6\n";
    my $filename = write_temp_csv($csv_content);
    my ($csv_hash, $header) = read_csv_data($filename);

    is_deeply($header, ['column0', 'column1', 'column2'], 'Header should match');
    is_deeply($csv_hash->{0}, { column0 => '1', column1 => '2', column2 => '3' }, 'First row should match');
    is_deeply($csv_hash->{1}, { column0 => '4', column1 => '5', column2 => '6' }, 'Second row should match');
}

# Negative scenario: Empty CSV file
{
    my $csv_content = "";
    my $filename = write_temp_csv($csv_content);
    my ($csv_hash, $header) = read_csv_data($filename);

    is_deeply($header, [], 'Header should be empty');
    is_deeply($csv_hash, {}, 'CSV hash should be empty');
}

# Edge scenario: CSV file with varying row lengths
{
    my $csv_content = "1,2\n3,4,5\n6\n";
    my $filename = write_temp_csv($csv_content);
    my ($csv_hash, $header) = read_csv_data($filename);

    is_deeply($header, ['column0', 'column1', 'column2'], 'Header should match');
    is_deeply($csv_hash->{0}, { column0 => '1', column1 => '2', column2 => '' }, 'First row should match with padding');
    is_deeply($csv_hash->{1}, { column0 => '3', column1 => '4', column2 => '5' }, 'Second row should match');
    is_deeply($csv_hash->{2}, { column0 => '6', column1 => '', column2 => '' }, 'Third row should match with padding');
}

# Positive scenario: Normal output
{
    my $csv_content = "1,2,3\n4,5,6\n";
    my $filename = write_temp_csv($csv_content);
    my ($csv_hash, $header) = read_csv_data($filename);
    my $output_file = "output_positive.csv";

    write_output($csv_hash, $header, $output_file);

    # Read and compare written output
    open my $output_fh, '<', $output_file or die "Error: Could not open '$output_file' for reading: $!\n";
    my @output_lines = <$output_fh>;
    close $output_fh;

    is_deeply(\@output_lines, [ "column0,column1,column2\n", "1,2,3\n", "4,5,6\n" ], 'Output file should match expected content');
}

# Negative scenario: Output file with permission denied
{
    my $csv_content = "1,2,3\n4,5,6\n";
    my $filename = write_temp_csv($csv_content);
    my ($csv_hash, $header) = read_csv_data($filename);
    my $output_file = "/root/output_permission_denied.csv";  # Assuming this path does not have write permissions

    # Test if write_output fails gracefully
    eval { write_output($csv_hash, $header, $output_file) };
    like($@, qr/Could not open .* for writing: Permission denied/, 'Correct error message for permission denied');
}

# Edge scenario: Output file in non-existent directory
{
    my $csv_content = "1,2,3\n4,5,6\n";
    my $filename = write_temp_csv($csv_content);
    my ($csv_hash, $header) = read_csv_data($filename);
    my $output_file = "/nonexistent_directory/output_nonexistent_directory.csv";

    # Test if write_output fails gracefully
    eval { write_output($csv_hash, $header, $output_file) };
    like($@, qr/Could not open .* for writing: No such file or directory/, 'Correct error message for non-existent directory');
}

done_testing(12);  # Update to match the actual number of tests executed
