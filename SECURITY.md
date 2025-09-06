# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it by:

1. **Email**: Create an issue in this repository with the label "security"
2. **Response Time**: We will respond within 48 hours
3. **Disclosure**: Please allow us time to address the issue before public disclosure

## Security Considerations

This project has a minimal attack surface:

- **No Network Calls**: The script operates entirely offline
- **No External Dependencies**: Uses only standard Unix tools (`bc`, `bash`)
- **Input Validation**: Accepts only numeric parameters via command line
- **No File System Access**: Does not read/write files beyond script execution
- **POSIX Compliant**: Uses standard shell constructs

## Security Best Practices

When using this script:

- Validate inputs before passing to the script
- Run in controlled environments for production use
- Review the simple script code before execution (it's only 12 lines)
- Use appropriate file permissions (755 for executable)

## Dependencies

- `bash` - System shell
- `bc` - Arbitrary precision calculator (standard Unix tool)

Both are standard system utilities with established security track records.