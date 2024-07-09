#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use lib '.';  # Ensure the script can find the modules
use CSVProcessor qw(read_csv_data write_output);
use DataProcessor qw(calculate_sums count_values calculate_percentages);

=head1 NAME

CSV Processor - A script to read, process, and write CSV files, and print statistics.

=head1 SYNOPSIS

perl read_write.pl -i input.csv -o output.csv

=head1 DESCRIPTION

This script reads a CSV file, processes its data, calculates sums, counts, and percentages for specific columns,
writes the processed data to an output file, and prints the calculated statistics.

=head1 OPTIONS

=over 8

=item B<-i>

Input CSV file.

=item B<-o>

Output CSV file.

=back

=head1 AUTHOR

Lucas Palma

=cut

sub main {
    my ($input_file, $output_file) = @_;

    # Read CSV data into a hash and get header
    my ($csv_hash, $header) = read_csv_data($input_file);

    # Calculate sums
    my $sums = calculate_sums($csv_hash, 3, 6);

    # Count positive and negative values
    my $counts = count_values($csv_hash, 3, 6);

    # Calculate percentages
    my $percentages = calculate_percentages($counts);

    # Write processed data to output file
    write_output($csv_hash, $header, $output_file);

    # Print sums, counts, and percentages
    print_data_summary($sums, $counts, $percentages);

    print "CSV file has been processed successfully and written to '$output_file'.\n";

    return 0;  # Return success code
}

sub print_data_summary {
    my ($sums, $counts, $percentages) = @_;

    foreach my $col (sort keys %$sums) {
        print "Column $col:\n";
        print "  Sum: $sums->{$col}\n";
        printf "  Positive: %d - %.2f%%\n", $counts->{$col}{positive}, $percentages->{$col}{positive};
        printf "  Negative: %d - %.2f%%\n", $counts->{$col}{negative}, $percentages->{$col}{negative};
    }
}

my $input_file;
my $output_file;

unless (caller) {
    GetOptions('i=s' => \$input_file, 'o=s' => \$output_file) or usage("Error: Invalid command line arguments.");

    unless (defined $input_file and defined $output_file) {
        usage("Error: Both input (-i) and output (-o) files must be specified.");
    }

    my $exit_code = main($input_file, $output_file);
    exit $exit_code;
}

sub usage {
    my ($message) = @_;
    die "$message\nUsage: $0 -i <Original CSV file> -o <Output CSV file>\n";
}
