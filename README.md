
# SQLMutant.sh

**Version:** 2.0  
**Author:** Chris 'SaintDruG' Abou-Chabké  
**Repository:** [GitHub: blackhatethicalhacking/SQLMutant](https://github.com/blackhatethicalhacking/SQLMutant)  
**Purpose:** Automated SQL Injection Testing Tool for Ethical Hacking and Security Assessments.

SQLMutant is a powerful automated tool that helps identify and exploit SQL injection vulnerabilities on target domains. It fetches URLs, filters them for potential injection points, and runs SQLMap to perform aggressive testing.

**Disclaimer**: This tool is intended for **authorized** security testing **only**. Unauthorized use of this tool on websites without proper authorization is illegal and unethical.

---

## Features

- **Automated SQL Injection Testing**: Fetch URLs, filter for potential SQL injection points, and test with SQLMap.
- **Supports Multiple Tools**: Integrates with `waybackurls`, `Arjun`, `httpx`, `sqlmap`, and more.
- **Virtual Environment Setup**: Ensures isolated Python dependencies using `virtualenv`.
- **Command-Line Arguments**: Allows customization for domain input, thread count, proxy settings, and authentication tokens.
- **Enhanced Error Handling**: Exits on errors and provides meaningful error messages.
- **Flexible Output**: Generates logs and saves SQLMap results in a dedicated output directory.
- **Proxy and Authentication Support**: Optional support for scanning via proxies and authenticated endpoints.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Command-Line Options](#command-line-options)
5. [How It Works](#how-it-works)
6. [Log Files and Output](#log-files-and-output)
7. [Ethical Use and Disclaimer](#ethical-use-and-disclaimer)
8. [Contributing](#contributing)
9. [License](#license)

---

## Requirements

### System Requirements
- Linux or macOS
- Basic understanding of shell scripting and penetration testing

### Dependencies
The script automatically checks for the following dependencies and installs them if missing:
- `lolcat`
- `figlet`
- `curl`
- `toilet`
- `virtualenv`
- `jq`
- `wget`
- `go`
- `pip3`
- `git`
- `python3`

Tools installed by the script:
- **SQLMap**
- **Arjun**
- **waybackurls**
- **httpx**
- **uro**

---

## Installation

### Step 1: Clone the Repository

Clone the SQLMutant repository from GitHub:

```bash
git clone https://github.com/blackhatethicalhacking/SQLMutant.git
cd SQLMutant
```

### Step 2: Make the Script Executable

Make the script executable:

```bash
chmod +x SQLMutant.sh
```

### Step 3: Run the Script with the Required Arguments

You can now run SQLMutant on a target domain:

```bash
./SQLMutant.sh -d example.com
```

---

## Usage

### Basic Usage

```bash
./SQLMutant.sh -d example.com
```

This command will:
1. Fetch URLs related to the target domain from the Wayback Machine.
2. Filter URLs for potential SQL injection points.
3. Run SQLMap on the filtered URLs with aggressive settings.

### Advanced Usage with Options

```bash
./SQLMutant.sh -d example.com -t 20 -p http://proxyserver:8080 -a your_auth_token
```

- **`-d example.com`**: Specifies the domain to scan.
- **`-t 20`**: Sets the number of threads for multi-threading (default is 10).
- **`-p http://proxyserver:8080`**: Runs the scan through the specified proxy server.
- **`-a your_auth_token`**: Includes an authentication token for authenticated endpoints.

---

## Command-Line Options

| Option            | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `-d`              | Target domain to scan (required).                                           |
| `-t`              | Number of threads to use (default: 10).                                     |
| `-p`              | Proxy server (e.g., `http://proxyserver:port`).                             |
| `-a`              | Authentication token for scanning protected domains.                        |
| `-h`              | Display help message and usage information.                                 |

---

## How It Works

1. **Fetch URLs**: The script uses `waybackurls` to retrieve archived URLs for the target domain.
2. **Filter URLs**: It filters URLs with potential query parameters using regular expressions and tools like `uro`.
3. **Arjun for Parameter Discovery**: It runs `Arjun` to find hidden HTTP parameters.
4. **Merge Results**: Merges all URLs and prepares them for SQL injection testing.
5. **Run SQLMap**: Executes `SQLMap` with aggressive tamper scripts, bypass techniques, and optimizations to test for SQL injection vulnerabilities.
6. **Results and Logging**: Saves SQLMap results and logs to a directory named after the target domain.

---

## Log Files and Output

- **Logs**: The script logs all output to `sqlmutant.log` in the target domain's directory.
- **SQLMap Results**: SQLMap results are saved in the directory structure:
  ```
  [domain-name]/
    ├── all_urls.txt
    ├── urls_with_params.txt
    ├── arjun_output.json
    ├── sqlmap_input.txt
    └── sqlmap_output/
  ```

You can review the SQLMap results in the `sqlmap_output` directory.

---

## Ethical Use and Disclaimer

This tool is designed for **authorized** security testing **only**. Unauthorized testing of websites and systems without explicit permission is illegal and unethical. Always ensure that you have the right to perform security assessments on the target system.

By using this tool, you agree to:

- Only test systems where you have explicit permission.
- Follow the responsible disclosure process when reporting vulnerabilities.
- Adhere to ethical hacking practices.

---

## Contributing

We welcome contributions from the security community! If you’d like to contribute to SQLMutant:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Submit a pull request with a detailed explanation of your changes.

---

## License

**SQLMutant.sh** is released under the **MIT License**. You can freely use, modify, and distribute this tool as long as you include the original license.

---

## Author and Contact

Developed by **Chris 'SaintDruG' Abou-Chabké** with ❤️ for the **blackhatethicalhacking.com** community.

If you have questions or suggestions, feel free to open an issue on GitHub or reach out via the [GitHub repository](https://github.com/blackhatethicalhacking/SQLMutant).

---

**Thank you for using SQLMutant! Happy ethical hacking!**
