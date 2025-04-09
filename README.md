# Neovim Config

<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/plugin-manager?style=flat" /></a>

## Install

> Install requires Neovim 0.9.4. Always review the code before installing a configuration.

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

  - neovim>=0.9.4, git
  - C compiler (gcc, clang, zig) as required by the tree-sitter plugin. On Alpine Lunux `musl-dev` is needed for header files. On Windows MSVC caused issues so Zig can be used instead.

- **Optional**:
  - **Fonts**: A [Nerd Font](https://www.nerdfonts.com/).
  - **LSPs**: Language servers are not automatically installed, but can be with `:Mason`. See `nvim-lspconfig.lua` for a list of included settings.
  - **Linters**: When an LSP does not provide a linter, one can be installed with `:Mason`. See `nvim-lint.lua` for a list of included settings.
  - **Formatters**: When an LSP does not provide a formatter, one can be installed with `:Mason`. See `conform.lua` for a list of included settings.
  - **Tools**:
    - [ripgrep](https://github.com/BurntSushi/ripgrep)
    - [lazygit](https://github.com/jesseduffield/lazygit)

## Plugins

Plugins are handled by the [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md) package manager. See `:h MiniDeps` for more details and `init.lua` for a list of installed plugins or the `snapshot` file for a quick list of plugins and version hashes.

## Todo

### Editor

- [x] Keep quickfix in focus when navigating items, until closed with `q`
- [x] Make use of some opensource code assistance ([avante](https://github.com/yetone/avante.nvim) with [ollama](https://ollama.ai))
- [x] Try setting up [nvim-dap](https://github.com/mfussenegger/nvim-dap) for some LSPs
- [ ] Replace tokyonight colorscheme with a base16 generated one

### Repo

- [ ] Setup [pre-commit](https://pre-commit.com/) hooks
