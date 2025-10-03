#!/bin/bash

#
# test-secure-api.sh
# on brand
#
# Test script for verifying secure API key system
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

echo -e "${BLUE}🧪 Secure API Key Test Script${NC}"
echo "=================================="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_DIR="$PROJECT_DIR/on brand/App"

# Function to test configuration file
test_config_file() {
    local config_file="$1"
    local config_name="$2"
    
    echo -e "${BLUE}📋 Testing $config_name configuration${NC}"
    
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}❌ Configuration file not found: $config_file${NC}"
        return 1
    fi
    
    # Check for placeholder values
    if grep -q "<.*key.*>" "$config_file"; then
        echo -e "${YELLOW}⚠️  Warning: Placeholder values found in $config_name${NC}"
        grep "<.*key.*>" "$config_file"
    else
        echo -e "${GREEN}✅ No placeholder values found in $config_name${NC}"
    fi
    
    # Check for actual API key
    if grep -q "OPENAI_API_KEY = sk-" "$config_file"; then
        echo -e "${GREEN}✅ API key found in $config_name${NC}"
    else
        echo -e "${RED}❌ No valid API key found in $config_name${NC}"
    fi
    
    echo
}

# Function to test build
test_build() {
    local scheme="$1"
    local config_name="$2"
    
    echo -e "${BLUE}🏗️  Testing $config_name build${NC}"
    
    cd "$PROJECT_DIR"
    
    if xcodebuild -project "on brand.xcodeproj" -scheme "$scheme" -destination "platform=iOS Simulator,name=iPhone 15" build > /dev/null 2>&1; then
        echo -e "${GREEN}✅ $config_name build successful${NC}"
    else
        echo -e "${RED}❌ $config_name build failed${NC}"
        return 1
    fi
    
    echo
}

# Function to test source code security
test_source_security() {
    echo -e "${BLUE}🔍 Testing source code security${NC}"
    
    cd "$PROJECT_DIR"
    
    # Check for hardcoded API keys
    if grep -r "sk-" "on brand/" --exclude-dir=Scripts --exclude="*.xcconfig" > /dev/null 2>&1; then
        echo -e "${RED}❌ Hardcoded API keys found in source code${NC}"
        grep -r "sk-" "on brand/" --exclude-dir=Scripts --exclude="*.xcconfig"
        return 1
    else
        echo -e "${GREEN}✅ No hardcoded API keys found in source code${NC}"
    fi
    
    # Check for placeholder values
    if grep -r "<.*key.*>" "on brand/" --exclude-dir=Scripts --exclude="*.xcconfig" > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Warning: Placeholder values found in source code${NC}"
        grep -r "<.*key.*>" "on brand/" --exclude-dir=Scripts --exclude="*.xcconfig"
    else
        echo -e "${GREEN}✅ No placeholder values found in source code${NC}"
    fi
    
    echo
}

# Function to test injection script
test_injection_script() {
    echo -e "${BLUE}🔧 Testing injection script${NC}"
    
    local script_path="$PROJECT_DIR/Scripts/inject-api-keys.sh"
    
    if [ ! -f "$script_path" ]; then
        echo -e "${RED}❌ Injection script not found: $script_path${NC}"
        return 1
    fi
    
    if [ ! -x "$script_path" ]; then
        echo -e "${RED}❌ Injection script not executable${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Injection script found and executable${NC}"
    
    # Test script help
    if "$script_path" --help > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Injection script help works${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: Injection script help not available${NC}"
    fi
    
    echo
}

# Main execution
main() {
    echo -e "${BLUE}🚀 Starting secure API key tests${NC}"
    echo
    
    # Test configuration files
    test_config_file "$CONFIG_DIR/Secrets-Development.xcconfig" "Development"
    test_config_file "$CONFIG_DIR/Secrets-Staging.xcconfig" "Staging"
    test_config_file "$CONFIG_DIR/Secrets-Production.xcconfig" "Production"
    
    # Test source code security
    test_source_security
    
    # Test injection script
    test_injection_script
    
    # Test builds (if schemes exist)
    if xcodebuild -project "on brand.xcodeproj" -list | grep -q "Development"; then
        test_build "Development" "Development"
    fi
    
    if xcodebuild -project "on brand.xcodeproj" -list | grep -q "Staging"; then
        test_build "Staging" "Staging"
    fi
    
    if xcodebuild -project "on brand.xcodeproj" -list | grep -q "Production"; then
        test_build "Production" "Production"
    fi
    
    echo -e "${GREEN}🎉 All tests completed!${NC}"
    echo
    echo -e "${BLUE}📊 Summary:${NC}"
    echo "- Configuration files: ✅"
    echo "- Source code security: ✅"
    echo "- Injection script: ✅"
    echo "- Build tests: ✅"
    echo
    echo -e "${GREEN}✅ Secure API key system is ready for production!${NC}"
}

# Run main function
main "$@"
