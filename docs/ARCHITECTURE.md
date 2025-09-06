# Architecture Documentation

## System Overview

The Simple Interest Calculator is designed as a modular, production-ready command-line tool following Unix philosophy and modern software engineering practices.

## Design Principles

### 1. Unix Philosophy
- **Do one thing well**: Focus on interest calculations
- **Text streams**: All output is human and machine readable
- **Composability**: Designed to work with other tools
- **Modularity**: Clear separation of concerns

### 2. Production Readiness
- **Error Handling**: Comprehensive validation and graceful failure
- **Security**: Input sanitization and injection protection
- **Performance**: Optimized for both small and large-scale usage
- **Maintainability**: Clean, documented, and testable code

### 3. Backward Compatibility
- **Legacy Support**: 100% compatible with original interface
- **Progressive Enhancement**: New features don't break existing usage
- **Graceful Degradation**: Works with minimal dependencies

## Core Components

### 1. Command Line Interface (CLI)
**Purpose**: Primary interface for user interaction

**Components**:
- Argument parser using `getopts`
- Help system with usage examples
- Version information display
- Interactive mode for guided input

**Design Decisions**:
- Used standard `getopts` for maximum compatibility
- Follows GNU/POSIX conventions for long and short options
- Provides multiple interaction modes (CLI, interactive, help)

### 2. Input Validation Layer
**Purpose**: Ensure data integrity and security

**Components**:
- Numeric validation with regex patterns
- Range checking for financial parameters
- Security validation against injection attacks
- Parameter completeness verification

**Design Decisions**:
- Fail-fast approach: validate early and provide clear errors
- Multiple validation layers for defense in depth
- Detailed error messages for user guidance

### 3. Calculation Engine
**Purpose**: Core mathematical operations

**Components**:
- Simple interest calculator: SI = (P × R × T) / 100
- Compound interest calculator: CI = P(1 + R/100)^T - P
- Precision control using BC calculator
- Formula verification and testing

**Design Decisions**:
- Used BC for arbitrary precision arithmetic
- Separated simple and compound interest for clarity
- Configurable precision (default: 2 decimal places)
- Mathematical accuracy verified with known test cases

### 4. Output Processing
**Purpose**: Format results for different use cases

**Components**:
- Text formatter for human-readable output
- JSON formatter for programmatic consumption
- CSV formatter for data analysis
- Currency formatter for international support

**Design Decisions**:
- Multiple output formats for flexibility
- Structured data includes metadata for traceability
- Currency formatting supports major international currencies
- Consistent formatting across all output types

### 5. Utility Layer
**Purpose**: Supporting functionality and infrastructure

**Components**:
- Logging system with configurable verbosity
- Error handling with appropriate exit codes
- Configuration management
- Dependency checking

**Design Decisions**:
- Modular utility functions for reusability
- Consistent error handling patterns
- Minimal external dependencies
- Comprehensive logging for debugging

## Error Handling Strategy

### 1. Input Validation Errors
- **Detection**: Early validation in input processing
- **Response**: Clear error messages with suggestions
- **Recovery**: Prompt for correct input in interactive mode

### 2. Calculation Errors
- **Detection**: Boundary checking and overflow detection
- **Response**: Graceful degradation with warnings
- **Recovery**: Alternative calculation methods if available

### 3. System Errors
- **Detection**: Dependency checking and environment validation
- **Response**: Informative error messages with installation help
- **Recovery**: Graceful exit with appropriate error codes

## Security Architecture

### 1. Input Sanitization
- **Validation**: Strict numeric validation with regex
- **Filtering**: Remove potentially dangerous characters
- **Escaping**: Proper escaping for shell operations

### 2. Command Injection Prevention
- **Parameter Binding**: Direct variable usage instead of command construction
- **Validation**: Reject inputs containing shell metacharacters
- **Isolation**: Use BC calculator safely with validated inputs

### 3. Output Security
- **Encoding**: Proper encoding for JSON and CSV output
- **Sanitization**: Remove potentially harmful characters from output
- **Validation**: Verify output format before display

## Performance Considerations

### 1. Startup Performance
- **Optimization**: Minimal initialization overhead
- **Caching**: Reuse validation results where possible
- **Lazy Loading**: Load components only when needed

### 2. Calculation Performance
- **Algorithm**: Efficient mathematical operations
- **Precision**: Configurable precision to balance accuracy and speed
- **Batching**: Support for multiple calculations

### 3. Memory Usage
- **Efficiency**: Minimal memory footprint
- **Cleanup**: Proper variable cleanup
- **Streaming**: Process large datasets without storing in memory

## Testing Strategy

### 1. Unit Testing
- **Coverage**: All functions and calculation paths
- **Edge Cases**: Boundary conditions and error cases
- **Mathematical Accuracy**: Verification with known results

### 2. Integration Testing
- **End-to-End**: Complete user workflows
- **Format Testing**: All output formats
- **Error Scenarios**: Error handling and recovery

### 3. Performance Testing
- **Benchmarking**: Performance under various loads
- **Stress Testing**: Large numbers and high frequency
- **Memory Testing**: Memory usage and leak detection

This architecture provides a solid foundation for current needs while remaining flexible for future enhancements and scaling requirements.
