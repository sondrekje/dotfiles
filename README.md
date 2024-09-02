# My dotfiles (Optimized for macOS, UNIX-like Friendly)

![Screenshot of tmux prompt with various shells](https://i.imgur.com/9b3PuzA.png)

These are my personal configuration files, modularized for different tools and environments. While the setup is tailored for macOS, it reflects my own preferences and optimizations. If you wish to use any of these configurations, I **highly encourage** you to review everything carefully and consult the official documentation for the tools you decide to use.

## Getting Started

### Installation

I've provided an installation script (``initial_install.sh``) that automates the process of installing dependencies. Aside from a few essential development tools, nothing is installed without confirmation. The script is idempotent, meaning it will silently skip any already installed dependencies or upgrade outdated ones. This allows you to safely re-run the script whenever new dependencies are added, ensuring your environment remains up-to-date.

**Note**: The installation script only supports macOS for now. Debian-based distros might be supported if/when I need them.

### Setting Up Symlinks

You can set up the necessary symlinks by running the `init_symlinks.sh` script. Like the installation script, it will prompt you for confirmation before creating or overwriting any existing symlinks.

### Customization

To customize these dotfiles, the easiest approach is to **fork the repository**. This way you can make changes specific to your setup while keeping the original structure intact.
You also get free version control for your dotfiles.

## Sections

Each section is self-contained and has its own ``README.md`` with specific instructions, allowing you to pick and choose the configurations you want. 

## Acknowledgments

This setup has been inspired by various community contributions, tutorials, and dotfiles from many developers over time. Thanks to everyone who shares their configurations and knowledge!

