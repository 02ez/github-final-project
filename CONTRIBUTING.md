# Contributing

Thank you for your interest in contributing to this project! Please follow these steps:

## Forking the Repository

You can fork this repository using the GitHub CLI:

```bash
gh repo fork https://github.com/02ez/github-final-project --clone
```

Or fork it using the GitHub web interface and then clone:

```bash
git clone https://github.com/YOUR_USERNAME/github-final-project.git
cd github-final-project
```

## Example: Forking Another Repository

If you want to fork and clone other repositories for learning purposes, you can use:

```bash
gh repo fork https://github.com/mcino/Introduction-to-Git-and-GitHub --clone
```

## Development Workflow

1. **Fork** the repository (see above)
2. **Branch** - Create a feature branch from main:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Commit** - Make your changes and commit:
   ```bash
   git add .
   git commit -m "Add your descriptive commit message"
   ```
4. **Push** - Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
5. **PR** - Create a Pull Request from your fork to the main repository

## Testing Your Changes

Before submitting a PR, test the simple interest calculator:

```bash
./simple-interest.sh -p 1000 -r 5 -t 2
```

Expected output:
```
Simple interest: 100.00
Total amount: 1100.00
```