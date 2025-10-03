#!/bin/bash

#
# inject-api-keys.sh
# on brand
#
# Build script for securely injecting API keys during build process.
# This script should be run as part of the CI/CD pipeline.
#
# Created by Pierson Davis on January 2025.
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$PROJECT_DIR/on brand/App"

echo -e "${BLUE}🔐 API Key Injection Script${NC}"
echo "=================================="

# Function to check if running in CI
is_ci() {
    if [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ] || [ -n "${JENKINS_URL:-}" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get API key from environment or prompt
get_api_key() {
    local key_name="$1"
    local env_var_name="$2"
    
    if [ -n "${!env_var_name:-}" ]; then
        echo "${!env_var_name}"
    elif is_ci; then
        echo -e "${RED}❌ Error: $key_name not found in environment variable $env_var_name${NC}"
        exit 1
    else
        echo -e "${YELLOW}⚠️  $key_name not found in environment.${NC}"
        read -s -p "Enter $key_name: " api_key
        echo
        if [ -z "$api_key" ]; then
            echo -e "${RED}❌ Error: $key_name cannot be empty${NC}"
            exit 1
        fi
        echo "$api_key"
    fi
}

# Function to validate API key format
validate_api_key() {
    local key="$1"
    local key_name="$2"
    
    if [[ ! "$key" =~ ^sk- ]]; then
        echo -e "${RED}❌ Error: $key_name must start with 'sk-'${NC}"
        exit 1
    fi
    
    if [ ${#key} -lt 20 ]; then
        echo -e "${RED}❌ Error: $key_name must be at least 20 characters long${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ $key_name format is valid${NC}"
}

# Function to create encrypted key
encrypt_key() {
    local key="$1"
    # Simple base64 encoding for now - in production, use proper encryption
    echo -n "$key" | base64
}

# Function to update xcconfig file
update_xcconfig() {
    local config_file="$1"
    local api_key="$2"
    local encrypted_key="$3"
    
    echo -e "${BLUE}📝 Updating $config_file${NC}"
    
    # Create backup
    cp "$config_file" "$config_file.backup"
    
    # Update the file
    sed -i.tmp "s/OPENAI_API_KEY = .*/OPENAI_API_KEY = $api_key/" "$config_file"
    sed -i.tmp "s/OPENAI_API_KEY_ENCRYPTED = .*/OPENAI_API_KEY_ENCRYPTED = $encrypted_key/" "$config_file"
    
    # Remove temporary file
    rm -f "$config_file.tmp"
    
    echo -e "${GREEN}✅ Updated $config_file${NC}"
}

# Main execution
main() {
    local build_configuration="${1:-Development}"
    
    echo -e "${BLUE}🏗️  Build Configuration: $build_configuration${NC}"
    
    # Determine which config file to use
    case "$build_configuration" in
        "Development")
            config_file="$CONFIG_DIR/Secrets-Development.xcconfig"
            env_var="OPENAI_API_KEY_DEV"
            ;;
        "Staging")
            config_file="$CONFIG_DIR/Secrets-Staging.xcconfig"
            env_var="OPENAI_API_KEY_STAGING"
            ;;
        "Production")
            config_file="$CONFIG_DIR/Secrets-Production.xcconfig"
            env_var="OPENAI_API_KEY_PROD"
            ;;
        *)
            echo -e "${RED}❌ Error: Invalid build configuration '$build_configuration'${NC}"
            echo "Valid options: Development, Staging, Production"
            exit 1
            ;;
    esac
    
    # Check if config file exists
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Error: Configuration file not found: $config_file${NC}"
        exit 1
    fi
    
    # Get API key
    echo -e "${BLUE}🔑 Getting API key for $build_configuration${NC}"
    api_key=$(get_api_key "OpenAI API Key" "$env_var")
    
    # Validate API key
    validate_api_key "$api_key" "OpenAI API Key"
    
    # Create encrypted version
    echo -e "${BLUE}🔒 Creating encrypted key${NC}"
    encrypted_key=$(encrypt_key "$api_key")
    
    # Update configuration file
    update_xcconfig "$config_file" "$api_key" "$encrypted_key"
    
    # Verify the update
    echo -e "${BLUE}🔍 Verifying configuration${NC}"
    if grep -q "OPENAI_API_KEY = $api_key" "$config_file"; then
        echo -e "${GREEN}✅ Configuration updated successfully${NC}"
    else
        echo -e "${RED}❌ Error: Configuration update failed${NC}"
        exit 1
    fi
    
    # Security check
    echo -e "${BLUE}🛡️  Security check${NC}"
    if grep -q "<.*key.*>" "$config_file"; then
        echo -e "${YELLOW}⚠️  Warning: Placeholder values found in configuration${NC}"
    else
        echo -e "${GREEN}✅ No placeholder values found${NC}"
    fi
    
    echo -e "${GREEN}🎉 API key injection completed successfully!${NC}"
}

# Run main function with all arguments
main "$@"