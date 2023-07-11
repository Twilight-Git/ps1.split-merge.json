# PowerShell JSON Split and Merge Scripts

This repository contains two PowerShell scripts: `split-json.ps1` and `merge-json.ps1`. These scripts allow you to split a large JSON file into smaller chunks based on the number of lines per file and merge the split files back into a single JSON file, respectively.

## split-json.ps1

The `split-json.ps1` script splits a JSON file into smaller chunks. It takes an input file, specified with the `-in` argument, and splits it into multiple smaller files based on the number of lines per file, specified with the `-li` argument.

### Usage

<code>.\split-json.ps1 -in &lt;inputFile&gt; -li &lt;linesPerFile&gt;</code>

### Arguments

- `-in`: Specifies the path to the input JSON file.
- `-li`: Specifies the number of lines per file for splitting the JSON file.

## merge-json.ps1

The `merge-json.ps1` script merges multiple JSON files into a single file. It assumes that the split JSON files are present in a directory named "split". It merges the contents of all the files in the "split" directory into a single output file.

### Usage

<code>.\merge-json.ps1</code>

### Prerequisites

Before running the `merge-json.ps1` script, ensure that you have previously run the `split-json.ps1` script to split the JSON file.

## Getting Started

To use these scripts, follow these steps:

1. Clone or download this repository to your local machine.
2. Open a PowerShell session.
3. Navigate to the directory containing the scripts.
4. Run the desired script using the provided usage instructions and arguments.

## License

This project is licensed under the [MIT License](LICENSE).

Feel free to use and modify these scripts to suit your needs.

## Contributing

Contributions are welcome! If you have any suggestions, improvements, or bug fixes, please open an issue or submit a pull request.