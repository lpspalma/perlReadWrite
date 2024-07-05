#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;
use Getopt::Long;

# Get command line arguments
my $input_file;
my $output_file;

GetOptions('i=s' => \$input_file, 'o=s' => \$output_file) or
    die "Usage: $0 -i <Original CSV file> -o <Output CSV file>\n";

# Check input and output files
if (not defined $input_file or not defined $output_file) {
    die "Usage: $0 -i <Original CSV file> -o <Output CSV file>\n";
}

# Open input file
open my $input, '<', $input_file or die "Could not open '$input_file': $!\n";

# Create parser
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

# Read all rows to determine the maximum number of columns
my @rows;
my $max_columns = 0;
while (my $row = $csv->getline($input)) {
    push @rows, $row;
    my $num_columns = scalar @$row;
    $max_columns = $num_columns if $num_columns > $max_columns;
}

# Create header
my @header = map { "column$_" } (0 .. $max_columns - 1);

# Open output file
open my $output, '>', $output_file or die "Could not open '$output_file': $!\n";

# Write header to output file
$csv->print($output, \@header);
print $output "\n";

# Write all rows of data to output file, ensuring each row has the correct number of columns
foreach my $row (@rows) {
    my @extended_row = (@$row, ('') x ($max_columns - @$row));
    $csv->print($output, \@extended_row);
    print $output "\n";
}

# Close filehandles
close $input;
close $output;

print "CSV file has been processed successfully.\n";
