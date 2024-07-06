#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;
use Getopt::Long;

# Subroutine to coordinate the script
sub main {
    my ($input_file, $output_file) = @_;

    # Read CSV data into a hash
    my $csv_hash = read_csv_data($input_file);

    # Calculate sums, counts, and percentages
    my ($sums, $counts, $percentages) = calculate_data($csv_hash, 3, 6);

    # Write processed data to output file
    write_output($csv_hash, $output_file);

    # Print sums, counts, and percentages
    print_data_summary($sums, $counts, $percentages);

    print "CSV file has been processed successfully and written to '$output_file'.\n";
}

sub read_csv_data {
    my ($input_file) = @_;
    open my $input, '<', $input_file or die "Could not open '$input_file': $!\n";
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

    my @rows;
    my $max_columns = 0;
    while (my $row = $csv->getline($input)) {
        push @rows, $row;
        my $num_columns = scalar @$row;
        $max_columns = $num_columns if $num_columns > $max_columns;
    }
    close $input;

    my @header = map { "column$_" } (0 .. $max_columns - 1);
    my %csv_hash;
    my $row_index = 0;

    foreach my $row (@rows) {
        my %row_hash;
        @row_hash{@header} = (@$row, ('') x ($max_columns - @$row));
        $csv_hash{$row_index} = \%row_hash;
        $row_index++;
    }

    return \%csv_hash;
}

# Function to calculate sums, counts, and percentages
sub calculate_data {
    my ($csv_hash, $start_column, $end_column) = @_;
    my %sums;
    my %counts;
    my %percentages;
    my $total_values = 0;

    foreach my $col_num ($start_column .. $end_column) {
        my $col_name = "column$col_num";
        $sums{$col_name} = 0;
        $counts{$col_name}{positive} = 0;
        $counts{$col_name}{negative} = 0;
        $counts{$col_name}{total} = 0;

        foreach my $row_index (keys %$csv_hash) {
            my $value = $csv_hash->{$row_index}{$col_name} || 0;
            $sums{$col_name} += $value;
            $total_values++;

            if ($value > 0) {
                $counts{$col_name}{positive}++;
            } elsif ($value < 0) {
                $counts{$col_name}{negative}++;
            }
        }

        # Calculate percentages
        $counts{$col_name}{total} = $counts{$col_name}{positive} + $counts{$col_name}{negative};
        $percentages{$col_name}{positive} = ($counts{$col_name}{positive} / $counts{$col_name}{total}) * 100;
        $percentages{$col_name}{negative} = ($counts{$col_name}{negative} / $counts{$col_name}{total}) * 100;
    }

    return (\%sums, \%counts, \%percentages, $total_values);
}

# Function to write output file
sub write_output {
    my ($csv_hash, $output_file) = @_;
    open my $out_fh, '>', $output_file or die "Could not open '$output_file' for writing: $!\n";

    my @header = sort keys %{ $csv_hash->{0} };
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });
    $csv->print($out_fh, \@header);
    print $out_fh "\n";

    foreach my $row_index (sort { $a <=> $b } keys %$csv_hash) {
        my @row_data = map { $csv_hash->{$row_index}{$_} } @header;
        $csv->print($out_fh, \@row_data);
        print $out_fh "\n";
    }

    close $out_fh;
}

# Function to print sums, counts, and percentages
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

GetOptions('i=s' => \$input_file, 'o=s' => \$output_file) or
    die "Usage: $0 -i <Original CSV file> -o <Output CSV file>\n";

if (not defined $input_file or not defined $output_file) {
    die "Usage: $0 -i <Original CSV file> -o <Output CSV file>\n";
}

# Run the main subroutine
main($input_file, $output_file);