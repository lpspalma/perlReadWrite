### CSV Processor Perl Script

**Overview**
This Perl script processes CSV files by performing data manipulation and generating statistics. It consists of modules for CSV file handling (CSVProcessor.pm) and data processing (DataProcessor.pm).

**Features**
- CSVProcessor Module: Handles reading CSV data into a hash and writing processed data back to CSV files.
- DataProcessor Module: Calculates sums, counts positive/negative values, and calculates percentages based on specified columns.
- Main Script (read_write.pl): Orchestrates the workflow, including command-line argument parsing, invoking data processing functions, and outputting results.

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
- perl csv_processor.pl -i <Input_CSV_file> -o <Output_CSV_file>
- -i <Input_CSV_file>: Specifies the input CSV file to be processed.
- -o <Output_CSV_file>: Specifies the output CSV file to which processed data will be written.


### Testing

#### Running Unit Tests

1. Navigate to the directory containing CSVProcessorTest.pl.
2. Execute the test script:
- perl CSVProcessorTest.pl
  - **Functions**
    -**read_csv_data**
      - Purpose: Reads CSV data from a file into a hash structure.
      - **Scenarios Tested**
        - Positive Scenario: Normal CSV data processing.
        - Negative Scenario: Empty CSV file handling.
        - Edge Scenario: CSV file with varying row lengths.
    -**write_output**
      - Purpose: Writes processed CSV data from a hash structure to an output file.
      - **Scenarios Tested**
        - Positive Scenario: Normal output file creation.
        - Negative Scenario: Output file in a non-existent directory.
        - Edge Scenario: Output file with permission denied
      
### Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please submit an issue or a pull request.

### License
This script is released under the same terms as Perl itself.

