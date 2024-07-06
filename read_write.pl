#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;
use Getopt::Long;

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

# Main subroutine to coordinate the script
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

# Subroutine to read CSV data
sub read_csv_data {
    my ($input_file) = @_;
    open my $input, '<', $input_file or die "Error: Could not open '$input_file': $!\n";
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

    my @rows;
    my $max_columns = 0;
    while (my $row = $csv->getline($input)) {
        push @rows, $row;
        my $num_columns = scalar @$row;
        $max_columns = $num_columns if $num_columns > $max_columns;
    }
    close $input;

    # Generate header based on maximum columns found
    my @header = map { "column$_" } (0 .. $max_columns - 1);

    my %csv_hash;
    my $row_index = 0;

    foreach my $row (@rows) {
        my %row_hash;
        @row_hash{@header} = (@$row, ('') x ($max_columns - @$row));
        $csv_hash{$row_index} = \%row_hash;
        $row_index++;
    }

    return (\%csv_hash, \@header);
}

# Subroutine to calculate sums
sub calculate_sums {
    my ($csv_hash, $start_column, $end_column) = @_;
    my %sums;

    foreach my $col_num ($start_column .. $end_column) {
        my $col_name = "column$col_num";
        $sums{$col_name} = 0;

        foreach my $row_index (keys %$csv_hash) {
            my $value = $csv_hash->{$row_index}{$col_name} || 0;
            $sums{$col_name} += $value;
        }
    }

    return \%sums;
}

# Subroutine to count positive and negative values
sub count_values {
    my ($csv_hash, $start_column, $end_column) = @_;
    my %counts;

    foreach my $col_num ($start_column .. $end_column) {
        my $col_name = "column$col_num";
        $counts{$col_name}{positive} = 0;
        $counts{$col_name}{negative} = 0;
        $counts{$col_name}{total} = 0;

        foreach my $row_index (keys %$csv_hash) {
            my $value = $csv_hash->{$row_index}{$col_name} || 0;

            if ($value > 0) {
                $counts{$col_name}{positive}++;
            } elsif ($value < 0) {
                $counts{$col_name}{negative}++;
            }
            $counts{$col_name}{total}++;
        }
    }

    return \%counts;
}

# Subroutine to calculate percentages
sub calculate_percentages {
    my ($counts) = @_;
    my %percentages;

    foreach my $col_name (keys %$counts) {
        if ($counts->{$col_name}{total} > 0) {
            $percentages{$col_name}{positive} = ($counts->{$col_name}{positive} / $counts->{$col_name}{total}) * 100;
            $percentages{$col_name}{negative} = ($counts->{$col_name}{negative} / $counts->{$col_name}{total}) * 100;
        } else {
            $percentages{$col_name}{positive} = 0;
            $percentages{$col_name}{negative} = 0;
        }
    }

    return \%percentages;
}

# Subroutine to write output file
sub write_output {
    my ($csv_hash, $header, $output_file) = @_;

    open my $output, '>', $output_file or die "Error: Could not open '$output_file' for writing: $!\n";
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

    # Write header to output file
    $csv->print($output, $header);
    print $output "\n";

    # Write each row of CSV data to output file
    foreach my $row_index (sort { $a <=> $b } keys %$csv_hash) {
        my @row_data = map { $csv_hash->{$row_index}{$_} } @$header;
        $csv->print($output, \@row_data);
        print $output "\n";
    }

    close $output;
}

# Subroutine to print sums, counts, and percentages
sub print_data_summary {
    my ($sums, $counts, $percentages) = @_;

    foreach my $col (sort keys %$sums) {
        print "Column $col:\n";
        print "  Sum: $sums->{$col}\n";
        printf "  Positive: %d - %.2f%%\n", $counts->{$col}{positive}, $percentages->{$col}{positive};
        printf "  Negative: %d - %.2f%%\n", $counts->{$col}{negative}, $percentages->{$col}{negative};
    }
}

# Command line argument parsing
my $input_file;
my $output_file;

GetOptions('i=s' => \$input_file, 'o=s' => \$output_file) or usage("Error: Invalid command line arguments.");

unless (defined $input_file and defined $output_file) {
    usage("Error: Both input (-i) and output (-o) files must be specified.");
}

# Run the main subroutine and handle errors
my $exit_code = main($input_file, $output_file);
exit $exit_code;

# Subroutine to display usage message and exit
sub usage {
    my ($message) = @_;
    die "$message\nUsage: $0 -i <Original CSV file> -o <Output CSV file>\n";
}