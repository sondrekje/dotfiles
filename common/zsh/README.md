# Zsh config (utilizing zinit)

This configuration uses [zinit](https://github.com/zdharma-continuum/zinit) to manage plugins and loads them using turbo mode. On an Apple M2, running `zsh_profile_startup` shows a total time of just 50ms even with all these plugins.
My motivation for switching from ``Oh My Zsh`` was the long startup time, which became increasingly disruptive to my workflow.

## Information

### Turbo-loading (via zinit)

The prompt will immediately respond to input while asynchronously loading the theme to avoid affecting startup time.
You can profile the startup time by running `zsh_profile_startup` (an alias from `.zshrc`).

### Dependencies

Some dependencies are required, while others are optional. I've tailored this setup according to my own needs.

- Git aliases from OMZ
- [fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting): A fast and feature-rich syntax highlighter.
- [navi](https://github.com/denisidoro/navi): Cheatsheet tool as a shell widget (activated using `<Ctrl>+g`).
- [nvm initialization](https://github.com/nvm-sh/nvm): Initializes NVM without affecting shell start-up time or lazy loading (zinit turbo).
- [SDKMAN initialization](https://github.com/sdkman/sdkman-cli): Initializes SDKMAN without affecting shell start-up time or lazy loading (zinit turbo).
- [zsh-completions](https://github.com/zsh-users/zsh-completions): Additional completions for Zsh.
- [zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use): Reminds you to use aliases you have but fail to use.
- [fzf](https://github.com/junegunn/fzf): Powerful command-line fuzzy-finder, used by many other plugins, including Navi.
- [zoxide](https://github.com/ajeetdsouza/zoxide): A smarter `cd` command that learns your most used directories. Bound to `z`.
- [fzf-git](https://github.com/junegunn/fzf-git): `fzf` integration for `git`, e.g., using `fzf` to search through `git checkout`.
- [fzf-tab](https://github.com/Aloxaf/fzf-tab): Replaces Zsh’s default selection menu with `fzf`.
- [eza](https://github.com/eza-community/eza): A modern alternative to `ls`.
- [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh): Replaced Powerlevel10k due to its move into life support. Loaded asynchronously to avoid affecting startup time.
- [bat](https://github.com/sharkdp/bat): Replaces `cat`, providing syntax highlighting and custom themes. Integrated for colored man pages, colored `--help` output, and `fzf` file preview (via `CTRL-T`).

