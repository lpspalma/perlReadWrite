package DataProcessor;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(calculate_sums count_values calculate_percentages);

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

1;
