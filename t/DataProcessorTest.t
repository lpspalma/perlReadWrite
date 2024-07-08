use strict;
use warnings;
use Test::More;
use lib '.';  # Ensure the test script can find the modules
use DataProcessor qw(calculate_sums count_values calculate_percentages);

# Mock CSV data for testing
my $csv_data = {
    1 => { column1 => 10, column2 => -5, column3 => 0 },
    2 => { column1 => 0, column2 => 8, column3 => -3 },
    3 => { column1 => -2, column2 => 3, column3 => 4 },
};

# Test for calculate_sums
my $sums = DataProcessor::calculate_sums($csv_data, 1, 3);
is($sums->{column1}, 8, "Sum calculation for column1 is correct");
is($sums->{column2}, 6, "Sum calculation for column2 is correct");
is($sums->{column3}, 1, "Sum calculation for column3 is correct");

# Test for count_values
my $counts = DataProcessor::count_values($csv_data, 1, 3);
is($counts->{column1}{positive}, 1, "Count positive values for column1 is correct");
is($counts->{column1}{negative}, 1, "Count negative values for column1 is correct");
is($counts->{column1}{total}, 3, "Total count for column1 is correct");

# Test for calculate_percentages
my $percentages = DataProcessor::calculate_percentages($counts);
is(sprintf("%.4f", $percentages->{column1}{positive}), sprintf("%.4f", 33.3333), "Percentage calculation for positive values in column1 is correct");
is(sprintf("%.4f", $percentages->{column1}{negative}), sprintf("%.4f", 33.3333), "Percentage calculation for negative values in column1 is correct");

# Edge case: Empty input data
my $empty_data = {};
my $empty_sums = DataProcessor::calculate_sums($empty_data, 1, 3);
is_deeply($empty_sums, { column1 => 0, column2 => 0, column3 => 0 }, "Empty data returns zero sums");

# Edge case: No negative values
my $no_negative_data = {
    1 => { column1 => 10, column2 => 5, column3 => 0 },
    2 => { column1 => 0, column2 => 8, column3 => 6 },
};
my $no_negative_counts = DataProcessor::count_values($no_negative_data, 1, 3);
is($no_negative_counts->{column1}{negative}, 0, "No negative values count is correct");

done_testing(10);  # Update the number to match the actual tests run