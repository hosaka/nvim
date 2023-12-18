# NeoVim Config

## Install

Use git to install and pull all submodules:

```
git clone --recursive https://github.com/hosaka/nvim
git submodules update --init --recursive
```

## Dependencies

- **Required**:

  - neovim>=0.8, git, [ripgrep](https://github.com/BurntSushi/ripgrep), [lazygit](https://github.com/jesseduffield/lazygit) (optional)

- **Optional**:
  - **Fonts**: A [Nerd Font](https://www.nerdfonts.com/).
  - **LSPs**: Language servers are not automatically installed, but can be with `:Mason`. See `nvim-lspconfig.lua` for a list of included settings.
  - **Linters**: When an LSP does not provide a linter, one can be installed with `:Mason`. See `nvim-lint.lua` for a list of included settings.
  - **Formatters**: When an LSP does not provide a formatter, one can be installed with `:Mason`. See `conform.lua` for a list of included settings.

## Package management

Plugins are added as git submodules to `pack/plugins/opt` and loaded with [packadd](https://neovim.io/doc/user/repeat.html#%3Apackadd).
Use `pack.sh` script (essentially a wrapper over some git commands) to date packages:

```
./pack.sh add --name <name> --url <url> --branch <branch>
./pack.sh remove --name <name>
./pack.sh update
```

## Todo

### Editor

- [ ] Keep quickfix in focus when navigating items, until closed with `q`
- [ ] Try setting up [nvim-dap](https://github.com/mfussenegger/nvim-dap) for some LSPs
- [ ] Make use of some opensource code assistance ([ollama](https://ollama.ai))
- [ ] Get mini.pairs to work nicely with nvim-cmp, perhaps needs a <CR> remap
- [ ] Replace tokyonight colorscheme with a base16 generated one

### Pack

- [ ] Rewrite `pack.sh` in lua, something lightweight like [paq](https://github.com/savq/paq-nvim)

### Repo

- [ ] Setup [pre-commit](https://pre-commit.com/) hooks
