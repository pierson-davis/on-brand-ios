# Devintest AI Development Tools - Complete Usage Guide

## Overview

The devintest implementation provides a comprehensive suite of AI-powered development tools that can significantly enhance your iOS development workflow. These tools integrate seamlessly with your "on brand" app development process.

## Quick Start

### 1. Environment Setup
```bash
# Navigate to project root
cd "/Users/piersondavis/Documents/on brand"

# Activate virtual environment
source venv/bin/activate

# Install dependencies (if not already done)
pip install -r devintest/requirements.txt
```

### 2. API Key Configuration
Create a `.env` file in the project root with your API keys:
```bash
# OpenAI
OPENAI_API_KEY=your_openai_key_here

# Anthropic
ANTHROPIC_API_KEY=your_anthropic_key_here

# Google (for Gemini)
GOOGLE_API_KEY=your_google_key_here

# Azure OpenAI (optional)
AZURE_OPENAI_API_KEY=your_azure_key_here
AZURE_OPENAI_ENDPOINT=https://your-endpoint.openai.azure.com
AZURE_OPENAI_MODEL_DEPLOYMENT=gpt-4o-ms

# DeepSeek (optional)
DEEPSEEK_API_KEY=your_deepseek_key_here

# SiliconFlow (optional)
SILICONFLOW_API_KEY=your_siliconflow_key_here
```

## Available Tools

### 1. LLM API (`devintest/tools/llm_api.py`)

**Purpose**: Multi-provider AI integration with vision capabilities

#### Basic Usage
```bash
# Simple text query
venv/bin/python3 devintest/tools/llm_api.py --prompt "What is the capital of France?" --provider "anthropic"

# With image analysis
venv/bin/python3 devintest/tools/llm_api.py --prompt "Describe this image" --image "screenshot.png" --provider "openai"
```

#### Supported Providers
- **OpenAI**: `gpt-4o` (default), `gpt-4o-mini`, `o1`
- **Anthropic**: `claude-3-7-sonnet-20250219` (default), `claude-3-5-sonnet-20241022`
- **Google Gemini**: `gemini-2.0-flash-exp` (default), `gemini-1.5-pro`
- **Azure OpenAI**: Configurable via environment
- **DeepSeek**: `deepseek-chat`
- **SiliconFlow**: `deepseek-ai/DeepSeek-R1`
- **Local LLM**: `Qwen/Qwen2.5-32B-Instruct-AWQ`

#### Advanced Features
```bash
# Use specific model
venv/bin/python3 devintest/tools/llm_api.py --prompt "Analyze this code" --provider "openai" --model "gpt-4o"

# Vision analysis with different providers
venv/bin/python3 devintest/tools/llm_api.py --prompt "Analyze this UI design" --image "ui_screenshot.png" --provider "gpt-4o"
```

### 2. Web Scraper (`devintest/tools/web_scraper.py`)

**Purpose**: Advanced web content extraction with concurrent processing

#### Basic Usage
```bash
# Single URL
venv/bin/python3 devintest/tools/web_scraper.py https://example.com

# Multiple URLs with concurrency control
venv/bin/python3 devintest/tools/web_scraper.py --max-concurrent 3 https://site1.com https://site2.com https://site3.com
```

#### Advanced Options
```bash
# Debug mode
venv/bin/python3 devintest/tools/web_scraper.py --debug https://example.com

# Custom concurrency
venv/bin/python3 devintest/tools/web_scraper.py --max-concurrent 5 https://example.com
```

### 3. Search Engine (`devintest/tools/search_engine.py`)

**Purpose**: DuckDuckGo search integration with retry mechanisms

#### Basic Usage
```bash
# Simple search
venv/bin/python3 devintest/tools/search_engine.py "SwiftUI best practices"

# With custom result count
venv/bin/python3 devintest/tools/search_engine.py "iOS development" --max-results 20
```

#### Advanced Options
```bash
# Custom retry attempts
venv/bin/python3 devintest/tools/search_engine.py "Firebase integration" --max-retries 5
```

### 4. Screenshot Utils (`devintest/tools/screenshot_utils.py`)

**Purpose**: Web page screenshot capture with configurable viewports

#### Basic Usage
```bash
# Default screenshot (1280x720)
venv/bin/python3 devintest/tools/screenshot_utils.py https://example.com

# Custom output path
venv/bin/python3 devintest/tools/screenshot_utils.py https://example.com --output "screenshot.png"

# Custom viewport size
venv/bin/python3 devintest/tools/screenshot_utils.py https://example.com --width 375 --height 812
```

## iOS Development Workflows

### 1. Code Analysis and Review

#### SwiftUI Code Review
```bash
# Review SwiftUI implementation
venv/bin/python3 devintest/tools/llm_api.py --prompt "Review this SwiftUI view for best practices, performance, and accessibility:

struct ContentView: View {
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                Text(\"Hello World\")
            }
        }
    }
}" --provider "anthropic"
```

#### Architecture Analysis
```bash
# Analyze MVVM implementation
venv/bin/python3 devintest/tools/llm_api.py --prompt "Analyze this MVVM architecture for the 'on brand' app:

class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var answers: [String: Any] = [:]
    
    func nextStep() {
        currentStep += 1
    }
}" --provider "openai"
```

### 2. UI/UX Validation

#### Screenshot Analysis
```bash
# Capture app screenshot
venv/bin/python3 devintest/tools/screenshot_utils.py https://your-app.com --width 375 --height 812 --output "app_screenshot.png"

# Analyze UI design
venv/bin/python3 devintest/tools/llm_api.py --prompt "Analyze this mobile app UI for:
1. Usability and user experience
2. Accessibility compliance
3. Design consistency
4. Visual hierarchy
5. Color contrast and readability

Provide specific recommendations for improvement." --image "app_screenshot.png" --provider "gpt-4o"
```

#### Design System Validation
```bash
# Validate design consistency
venv/bin/python3 devintest/tools/llm_api.py --prompt "Review this design system implementation for consistency:

// ThemeManager colors
extension ThemeManager {
    var primary: Color { Color.blue }
    var secondary: Color { Color.purple }
    var textPrimary: Color { Color.primary }
    var textSecondary: Color { Color.secondary }
}

// Usage in views
Text(\"Hello\")
    .foregroundColor(themeManager.textPrimary)
    .background(themeManager.surface)

Provide feedback on:
1. Color naming conventions
2. Usage patterns
3. Dark mode support
4. Accessibility considerations" --provider "anthropic"
```

### 3. Feature Development

#### Competitor Research
```bash
# Research competitor apps
venv/bin/python3 devintest/tools/web_scraper.py --max-concurrent 3 https://competitor1.com https://competitor2.com https://competitor3.com

# Analyze competitor features
venv/bin/python3 devintest/tools/llm_api.py --prompt "Based on the scraped content, analyze competitor features for the 'on brand' app:

[Paste scraped content here]

Focus on:
1. Unique features we could implement
2. UI/UX patterns we should adopt
3. User experience improvements
4. Technical implementations to consider" --provider "openai"
```

#### Technical Research
```bash
# Search for technical solutions
venv/bin/python3 devintest/tools/search_engine.py "SwiftUI Firebase real-time sync best practices 2024"

# Analyze technical solutions
venv/bin/python3 devintest/tools/llm_api.py --prompt "Review these technical solutions for Firebase integration:

[Paste search results here]

Recommend the best approach for:
1. Real-time data synchronization
2. Offline support
3. Performance optimization
4. Error handling" --provider "anthropic"
```

### 4. Testing and Quality Assurance

#### AI Feature Testing
```bash
# Test AI email parsing
venv/bin/python3 devintest/tools/llm_api.py --prompt "Test this AI email parsing feature with sample influencer deal emails:

[Paste your AI email parsing code here]

Test with these scenarios:
1. Standard influencer deal email
2. Email with multiple requirements
3. Email with unclear formatting
4. Email with missing information

Provide feedback on accuracy and error handling." --provider "openai"
```

#### Performance Analysis
```bash
# Analyze performance bottlenecks
venv/bin/python3 devintest/tools/llm_api.py --prompt "Analyze this code for performance issues:

[Paste your code here]

Focus on:
1. Memory usage patterns
2. CPU-intensive operations
3. Network call optimization
4. UI rendering performance
5. Background task management" --provider "anthropic"
```

### 5. Error Handling and Debugging

#### Error Handling Review
```bash
# Review error handling implementation
venv/bin/python3 devintest/tools/llm_api.py --prompt "Review this error handling code:

[Paste your error handling code here]

Evaluate:
1. Completeness of error coverage
2. User-friendly error messages
3. Recovery mechanisms
4. Logging and debugging information
5. Edge case handling" --provider "openai"
```

#### Debugging Assistance
```bash
# Get debugging help
venv/bin/python3 devintest/tools/llm_api.py --prompt "Help debug this issue:

Problem: App crashes when switching themes
Error: 'No ObservableObject of type ThemeManager found'
Code: [Paste relevant code here]

Provide:
1. Root cause analysis
2. Step-by-step debugging approach
3. Code fixes
4. Prevention strategies" --provider "anthropic"
```

## Advanced Workflows

### 1. Complete Feature Development Cycle

```bash
# 1. Research phase
venv/bin/python3 devintest/tools/search_engine.py "influencer deal management app features"
venv/bin/python3 devintest/tools/llm_api.py --prompt "Analyze these features for our app" --provider "openai"

# 2. Design phase
venv/bin/python3 devintest/tools/screenshot_utils.py https://competitor.com --output "competitor_ui.png"
venv/bin/python3 devintest/tools/llm_api.py --prompt "Design UI for influencer deals feature" --image "competitor_ui.png" --provider "gpt-4o"

# 3. Development phase
venv/bin/python3 devintest/tools/llm_api.py --prompt "Implement SwiftUI view for deal management" --provider "anthropic"

# 4. Testing phase
venv/bin/python3 devintest/tools/llm_api.py --prompt "Create test cases for this feature" --provider "openai"

# 5. Review phase
venv/bin/python3 devintest/tools/llm_api.py --prompt "Review complete implementation" --provider "anthropic"
```

### 2. Continuous Integration Testing

```bash
# Automated code review
venv/bin/python3 devintest/tools/llm_api.py --prompt "Review recent changes for quality and consistency" --provider "openai"

# Performance regression testing
venv/bin/python3 devintest/tools/llm_api.py --prompt "Check for performance regressions in recent changes" --provider "anthropic"

# Security review
venv/bin/python3 devintest/tools/llm_api.py --prompt "Security review of API integrations and data handling" --provider "openai"
```

### 3. Documentation Generation

```bash
# Generate API documentation
venv/bin/python3 devintest/tools/llm_api.py --prompt "Generate comprehensive documentation for this API service" --provider "anthropic"

# Create user guides
venv/bin/python3 devintest/tools/llm_api.py --prompt "Create user guide for this feature" --provider "openai"

# Generate code comments
venv/bin/python3 devintest/tools/llm_api.py --prompt "Add comprehensive comments to this code" --provider "anthropic"
```

## Best Practices

### 1. API Key Management
- Store API keys in `.env` file (never commit to version control)
- Use different keys for different environments
- Rotate keys regularly
- Monitor API usage and costs

### 2. Prompt Engineering
- Be specific and detailed in prompts
- Provide context about your app and requirements
- Use examples when possible
- Iterate and refine prompts based on results

### 3. Tool Selection
- Use LLM API for code analysis and generation
- Use web scraper for research and data gathering
- Use search engine for finding solutions
- Use screenshot utils for UI validation

### 4. Integration with Development Workflow
- Run AI analysis before committing code
- Use tools for code review and quality assurance
- Integrate with your testing process
- Use for documentation and knowledge management

## Troubleshooting

### Common Issues

#### 1. API Key Errors
```bash
# Check if API key is loaded
venv/bin/python3 devintest/tools/llm_api.py --prompt "Test API key" --provider "openai"
```

#### 2. Network Issues
```bash
# Test web scraping
venv/bin/python3 devintest/tools/web_scraper.py https://httpbin.org/get
```

#### 3. Screenshot Issues
```bash
# Test screenshot capture
venv/bin/python3 devintest/tools/screenshot_utils.py https://example.com --output "test.png"
```

### Getting Help

1. Check the tool's help: `venv/bin/python3 devintest/tools/llm_api.py --help`
2. Review error messages and logs
3. Test with simple examples first
4. Use AI tools to debug issues: `venv/bin/python3 devintest/tools/llm_api.py --prompt "Help debug this error" --provider "anthropic"`

## Integration with Cursor Rules

The devintest tools are fully integrated with your cursor rules:

- **ai-services.mdc**: Enhanced with devintest AI testing capabilities
- **testing-debugging.mdc**: Includes AI-powered testing workflows
- **feature-development.mdc**: Incorporates AI-enhanced development processes
- **.cursorrules**: Updated with devintest tool documentation

## Conclusion

The devintest tools provide a powerful suite of AI-enhanced development capabilities that can significantly improve your iOS development workflow. By integrating these tools with your existing development process, you can:

- Improve code quality through AI analysis
- Accelerate feature development with AI assistance
- Enhance testing with AI validation
- Streamline research and competitor analysis
- Optimize UI/UX with AI feedback

Start with simple use cases and gradually integrate more advanced workflows as you become comfortable with the tools.
