# API Documentation

## Simple Interest Calculator API Reference

This document provides comprehensive documentation for the Simple Interest Calculator CLI tool.

## Command Line Interface

### Syntax
```bash
simple-interest.sh -p <principal> -r <rate_%> -t <years> [options]
```

### Required Arguments

| Parameter | Description | Type | Constraints |
|-----------|-------------|------|-------------|
| `-p <principal>` | Principal amount | Number | Must be positive |
| `-r <rate_%>` | Annual interest rate as percentage | Number | Must be positive |
| `-t <years>` | Time period in years | Number | Must be positive |

### Optional Arguments

| Parameter | Description | Default | Valid Values |
|-----------|-------------|---------|--------------|
| `-c` | Enable compound interest mode | Simple | N/A |
| `-f <format>` | Output format | text | text, json, csv |
| `-u <currency>` | Currency code for formatting | USD | Any valid currency code |
| `-i` | Interactive mode with prompts | Disabled | N/A |
| `-v` | Verbose output | Disabled | N/A |
| `-h` | Show help message | N/A | N/A |
| `--version` | Show version information | N/A | N/A |

## Functions

### Mathematical Functions

#### Simple Interest Calculation
```bash
calculate_simple_interest(principal, rate, time)
```
**Formula**: SI = (P × R × T) / 100

**Parameters**:
- `principal`: The initial amount of money
- `rate`: Annual interest rate as percentage
- `time`: Time period in years

**Returns**: Simple interest amount

#### Compound Interest Calculation
```bash
calculate_compound_interest(principal, rate, time)
```
**Formula**: CI = P × (1 + R/100)^T - P

**Parameters**:
- `principal`: The initial amount of money
- `rate`: Annual interest rate as percentage
- `time`: Time period in years

**Returns**: Compound interest amount

### Utility Functions

#### Input Validation
```bash
validate_positive_number(value, param_name)
```
Validates that a given value is a positive number.

**Parameters**:
- `value`: The value to validate
- `param_name`: Name of parameter for error messages

**Returns**: 0 for valid, 1 for invalid

#### Currency Formatting
```bash
format_currency(amount, currency)
```
Formats a monetary amount with appropriate currency symbol.

**Parameters**:
- `amount`: Numeric amount to format
- `currency`: Currency code (USD, EUR, GBP, etc.)

**Returns**: Formatted currency string

## Output Formats

### Text Format (Default)
```
=== Interest Calculation Results ===
Principal Amount: $1000.00
Interest Rate: 5% per annum
Time Period: 2 years
Calculation Mode: Simple Interest
---
Simple Interest: $100.00
Total Amount: $1100.00
```

### JSON Format
```json
{
  "calculation": {
    "principal": 1000,
    "rate": 5,
    "time": 2,
    "currency": "USD",
    "mode": "Simple Interest"
  },
  "results": {
    "interest": 100.00,
    "total": 1100.00
  },
  "metadata": {
    "script_version": "1.0.0",
    "timestamp": "2025-09-06T06:00:00Z",
    "formula": "(P * R * T) / 100"
  }
}
```

### CSV Format
```csv
principal,rate,time,currency,mode,interest,total,timestamp
1000,5,2,USD,Simple Interest,100.00,1100.00,2025-09-06T06:00:00Z
```

## Currency Support

### Supported Currencies

| Currency | Code | Symbol | Example |
|----------|------|--------|---------|
| US Dollar | USD | $ | $1000.00 |
| Euro | EUR | € | €1000.00 |
| British Pound | GBP | £ | £1000.00 |
| Japanese Yen | JPY | ¥ | ¥1000 |
| Indian Rupee | INR | ₹ | ₹1000.00 |
| Custom | Any | - | 1000.00 CODE |

## Error Codes

| Exit Code | Description |
|-----------|-------------|
| 0 | Success |
| 1 | Invalid input parameters |
| 2 | Missing dependencies |
| 3 | File system errors |

## Examples

### Basic Calculations
```bash
# Simple interest for $1000 at 5% for 2 years
./simple-interest.sh -p 1000 -r 5 -t 2

# Compound interest with verbose output
./simple-interest.sh -p 5000 -r 7.5 -t 3 -c -v

# JSON output in Euros
./simple-interest.sh -p 2000 -r 4 -t 5 -f json -u EUR
```

### Advanced Usage
```bash
# Interactive mode
./simple-interest.sh -i

# CSV output for data processing
./simple-interest.sh -p 10000 -r 3.5 -t 10 -f csv > results.csv

# Large number calculation
./simple-interest.sh -p 999999999 -r 12 -t 30 -c
```

## Integration

### Shell Scripts
```bash
#!/bin/bash
result=$(./simple-interest.sh -p 1000 -r 5 -t 2 -f json)
echo "$result" | jq '.results.interest'
```

### Data Processing
```bash
# Generate multiple calculations
for p in 1000 5000 10000; do
    ./simple-interest.sh -p "$p" -r 5 -t 2 -f csv
done > batch_results.csv
```

## Limitations

- Maximum precision: 10 decimal places
- Maximum number size: Limited by BC calculator capabilities
- Floating-point arithmetic: Subject to standard precision limits
- Currency formatting: Display only, no conversion rates

## Security Considerations

- All inputs are validated and sanitized
- No execution of user-provided code
- Protection against command injection
- Safe handling of special characters

## Performance

- Optimized for batch processing
- Minimal memory footprint
- Fast startup time
- Efficient for large numbers

For more detailed information, see the [User Manual](USER_MANUAL.md) and [Developer Guide](DEVELOPER.md).
