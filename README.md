# mac-setup

Automated macOS development environment setup. Installs dev tools, configures shell, and sets up editors.

[![License](https://img.shields.io/badge/license-MIT-blue)]()

## Prerequisites

- macOS 12.0+
- [Homebrew](https://brew.sh) installed
- Xcode Command Line Tools (`xcode-select --install`)

## First Time Setup

```bash
git clone https://github.com/yourusername/mac-setup.git ~/Source/mac-setup
cd ~/Source/mac-setup
./setup.sh
```

Restart your terminal when done.

## Usage

After first setup, use the `mac` alias:

```bash
mac                 # Run setup (safe to run multiple times)
mac --verbose       # Show detailed output
mac --dry-run       # Preview what would be installed
mac --upgrade       # Upgrade all Homebrew packages
mac --verify        # Check installation status
mac --help          # Show all options
```
