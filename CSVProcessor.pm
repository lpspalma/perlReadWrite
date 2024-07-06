package CSVProcessor;
use strict;
use warnings;
use Text::CSV;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(read_csv_data write_output);

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

sub write_output {
    my ($csv_hash, $header, $output_file) = @_;
    open my $output, '>', $output_file or die "Error: Could not open '$output_file' for writing: $!\n";
    my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

    $csv->print($output, $header);
    print $output "\n";

    foreach my $row_index (sort { $a <=> $b } keys %$csv_hash) {
        my @row_data = map { $csv_hash->{$row_index}{$_} } @$header;
        $csv->print($output, \@row_data);
        print $output "\n";
    }

    close $output;
}

1;
