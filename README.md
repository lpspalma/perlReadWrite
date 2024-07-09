### CSV Processor Perl Script

**Overview**
This Perl script processes CSV files by performing data manipulation and generating statistics. It consists of modules for CSV file handling (CSVProcessor.pm) and data processing (DataProcessor.pm).

**Features**
- CSVProcessor Module: Handles reading CSV data into a hash and writing processed data back to CSV files.
- DataProcessor Module: Calculates sums, counts positive/negative values, and calculates percentages based on specified columns.
- Main Script (main.pl): Orchestrates the workflow, including command-line argument parsing, invoking data processing functions, and outputting results.

**Dependencies**
- Perl 5
- Required Perl modules:
- - Text::CSV: For handling CSV files.
  - Getopt::Long: For command-line argument parsing.
  - File::Temp: For creating temporary files in tests.
  - Test::More: For writing unit tests.

**Installation**
- Perl Installation: Ensure Perl 5 is installed on your system.
- Module Installation: Install required Perl modules using CPAN or your preferred package manager: cpan Text::CSV Getopt::Long File::Temp Test::More


**Usage**
**Running the Script**
- perl main.pl -i <Input_CSV_file> -o <Output_CSV_file>
- -i <Input_CSV_file>: Specifies the input CSV file to be processed.
- -o <Output_CSV_file>: Specifies the output CSV file to which processed data will be written.


### Testing

#### Running Unit Tests

1. Navigate to the directory t where you will find all unit tests.
2. Execute the test script:
- perl CSVProcessorTest.pl
- or run prove t/*.t to run all tests at once
  - **Functions**
    - **read_csv_data**
      - Purpose: Reads CSV data from a file into a hash structure.
      - **Scenarios Tested**
        - *Positive Scenario*: Normal CSV data processing.
        - *Negative Scenario*: Empty CSV file handling.
        - *Edge Scenario*: CSV file with varying row lengths.
        
    - **write_output**
      - Purpose: Writes processed CSV data from a hash structure to an output file.
      - **Scenarios Tested**
        - *Positive Scenario*: Normal output file creation.
        - *Negative Scenario*: Output file in a non-existent directory.
        - *Edge Scenario*: Output file with permission denied

    - **calculate_sums**
      - Purpose: Calculates sums for specified columns in a CSV data hash.
      - **Scenarios Tested**
        - *Positive Scenario*: Validates correct sum calculation for columns with mixed positive and negative values.
        - *Edge Case*: Handles cases where the CSV data has varying row lengths gracefully.
        - *Edge Case*: Verifies that the function returns zero sums correctly when given empty input data.

    - **count_values**
      - Purpose: Counts occurrences of positive and negative values in specified columns of a CSV data hash.
      - **Scenarios Tested**
        - *Positive Scenario*: Ensures accurate counting of positive and negative values in columns with mixed data.
        - *Edge Case*: Validates that the function correctly identifies columns with no negative values.
        - *Edge Case*: Tests handling of CSV data with varying row lengths to ensure consistent behavior.
        
    - **calculate_percentages**
      - Purpose: Calculates percentages of positive and negative values relative to the total count for specified columns.
      - **Scenarios Tested**
        - *Positive Scenario*: Verifies accurate percentage calculation for positive and negative values in columns with mixed data.
        - *Edge Case*: Ensures correct percentage calculation when all values in a column are of the same type (e.g., all positive or all negative).
