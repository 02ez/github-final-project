# Security Policy

## Supported Versions

We actively support the following versions of the Simple Interest Calculator:

| Version | Supported          | End of Life |
| ------- | ------------------ | ----------- |
| 1.0.x   | :white_check_mark: | TBD         |
| < 1.0   | :x:                | 2025-09-06  |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 1. **DO NOT** create a public GitHub issue

Security vulnerabilities should be reported privately to protect users.

### 2. Report via Email

Send details to: **security@github-final-project.example.com** (or create a private security advisory on GitHub)

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if available)

### 3. Report via GitHub Security Advisories

1. Go to the [Security tab](https://github.com/02ez/github-final-project/security)
2. Click "Report a vulnerability"
3. Fill out the private security advisory form

## What to Include in Your Report

Please provide as much information as possible:

- **Vulnerability Type**: (e.g., Command Injection, Input Validation, etc.)
- **Component**: Which part of the system is affected
- **Severity**: Your assessment of the impact
- **Reproduction Steps**: Detailed steps to reproduce the issue
- **Proof of Concept**: Example code or commands (if safe to share)
- **Suggested Mitigation**: How to fix or work around the issue
- **Your Contact Information**: For follow-up questions

## Response Timeline

- **Acknowledgment**: Within 24 hours
- **Initial Assessment**: Within 72 hours  
- **Detailed Response**: Within 1 week
- **Fix Timeline**: Depends on severity
  - Critical: Within 24-48 hours
  - High: Within 1 week
  - Medium: Within 2 weeks
  - Low: Next scheduled release

## Vulnerability Disclosure Process

1. **Report Received**: We acknowledge receipt and begin investigation
2. **Validation**: We confirm and assess the vulnerability
3. **Fix Development**: We develop and test a fix
4. **Coordinator Disclosure**: We coordinate with you on disclosure timing
5. **Public Release**: We release the fix and publish a security advisory
6. **Recognition**: We credit you in our security advisories (if desired)

## Security Measures

### Current Security Features

- **Input Validation**: All user inputs are validated and sanitized
- **Command Injection Protection**: No user input is passed to shell commands
- **Error Handling**: Secure error messages that don't leak sensitive information
- **Dependency Security**: Minimal dependencies, all regularly updated
- **Code Review**: All changes undergo security review
- **Automated Scanning**: CI/CD pipeline includes security scans

### Security Testing

We regularly perform:
- Static code analysis with ShellCheck
- Input fuzzing and validation testing
- Command injection testing
- Dependency vulnerability scanning
- Security-focused code reviews

## Security Best Practices for Users

### For Developers
- Always run the latest version
- Review code changes before deploying
- Use the tool in sandboxed environments for testing
- Report any suspicious behavior immediately

### For Production Use
- Validate all inputs before passing to the calculator
- Run with minimal privileges
- Monitor for unusual activity
- Keep dependencies updated
- Use version pinning in automated systems

## Known Security Considerations

### Input Validation
- The calculator validates all numeric inputs
- Special characters in financial parameters are rejected
- Command injection attempts are blocked

### Environment Security
- Script requires minimal system permissions
- No network access required
- No persistent data storage
- Temporary files are properly cleaned up

### Dependencies
- **BC Calculator**: System dependency, regularly updated
- **Bash**: Standard shell, keep system updated
- **Bats**: Testing framework, development only

## Security Contact

- **Primary**: Security Team via GitHub Security Advisories
- **Backup**: Project maintainers via GitHub issues (for non-sensitive matters)
- **GPG Key**: Available upon request for encrypted communications

## Security Hall of Fame

We recognize security researchers who help improve our security:

*No vulnerabilities reported yet - be the first to help us improve!*

## Legal

- We will not pursue legal action against researchers who follow this policy
- We support responsible disclosure and will work with you on timing
- Public credit will be given unless you prefer to remain anonymous
- We may offer small tokens of appreciation for significant findings

## Additional Resources

- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
- [CWE/SANS Top 25 Software Errors](https://cwe.mitre.org/top25/archive/2023/2023_top25_list.html)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

**Last Updated**: September 6, 2025  
**Policy Version**: 1.0