# NeoVim Config

## Install

Clone the repo to a location where it can be loaded by neovim:

```
git clone --filter=blob:none https://code.hosaka.cc/hosaka/nvim.git ~/.config/nvim
```

## Dependencies

- **Required**:

  - neovim>=0.10 (nightly), git, [ripgrep](https://github.com/BurntSushi/ripgrep), [lazygit](https://github.com/jesseduffield/lazygit) (optional)

- **Optional**:
  - **Fonts**: A [Nerd Font](https://www.nerdfonts.com/).
  - **LSPs**: Language servers are not automatically installed, but can be with `:Mason`. See `nvim-lspconfig.lua` for a list of included settings.
  - **Linters**: When an LSP does not provide a linter, one can be installed with `:Mason`. See `nvim-lint.lua` for a list of included settings.
  - **Formatters**: When an LSP does not provide a formatter, one can be installed with `:Mason`. See `conform.lua` for a list of included settings.

## Package management

Plugins are handled by the [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md) package manager. See `:h MiniDeps` for more details and `init.lua` for a list of installed plugins. Version hashes are stored in `mini-deps-snap` snapshot file.

## Todo

### Editor

- [ ] Keep quickfix in focus when navigating items, until closed with `q`
- [ ] Try setting up [nvim-dap](https://github.com/mfussenegger/nvim-dap) for some LSPs
- [ ] Make use of some opensource code assistance ([ollama](https://ollama.ai))
- [ ] Replace tokyonight colorscheme with a base16 generated one

### Repo

- [ ] Setup [pre-commit](https://pre-commit.com/) hooks
