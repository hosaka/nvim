# Neovim Config

<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/plugin-manager?style=flat" /></a>

## Install

> Install requires Neovim 0.12. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:hosaka/nvim ~/.config/hosaka/nvim
```

Open Neovim with this config:

```sh
NVIM_APPNAME=hosaka/nvim/ nvim
```

## Dependencies

- **Required**:

  - neovim>=0.12, tree-sitter>=0.25, git
  - C compiler (gcc, clang, zig) as required by tree-sitter. On Alpine Lunux `musl-dev` is needed for header files. If MSVC on Windows causes issues, Zig can be used instead.

- **Optional**:
  - **Fonts**: Any [Nerd Font](https://www.nerdfonts.com/).
  - **LSPs**: Language servers are not automatically installed. Use your OS package manager or [mise](https://mise.jdx.dev/dev-tools/) to install them. See `nvim-lspconfig.lua` for a list of included settings.
  - **Linters**: When an LSP does not provide diagnostic messages, a linter can be used with nvim-lint. See `nvim-lint.lua` for a list of included settings.
  - **Formatters**: When an LSP does not provide a formatter, one can be defined manually with Conform. See `conform.lua` for a list of included settings.
  - **Tools**:
    - [ripgrep](https://github.com/BurntSushi/ripgrep): plugins like `mini.pick` use this for faster grep.
    - [lazygit](https://github.com/jesseduffield/lazygit): a default `<Leader>gg` is mapped to open lazygit.

## Plugins

Plugins are managed using Neovim [built-in package manager](https://neovim.io/doc/user/pack) and loaded using async helpers from `mini.misc`.

I have previously used [mini.deps](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-deps.md) as a package manager and it was a pleasure to work with, especially the plugin update/clean functions.

## Todo

### Editor

- [x] Keep quickfix in focus when navigating items, until closed with `q`
- [x] Try setting up [nvim-dap](https://github.com/mfussenegger/nvim-dap) for some LSPs
- [ ] Replace tokyonight colorscheme with a base16 generated one

### Repo

- [x] Setup [pre-commit](https://pre-commit.com/) hooks

## Mirrors
This repository is hosted on [Forgejo](https://code.hosaka.cc/hosaka/nvim) which mirrors to the following git forges:
- [<img src="https://raw.githubusercontent.com/humanetech-community/awesome-humane-tech/main/logo/codeberg.svg?sanitize=true" width="16"/>](https://codeberg.org/hosaka/nvim) - https://codeberg.org/hosaka/nvim
- [<img src="https://raw.githubusercontent.com/humanetech-community/awesome-humane-tech/main/logo/github.svg?sanitize=true" width="16"/>](https://github.com/hosaka/nvim) - https://github.com/hosaka/nvim
