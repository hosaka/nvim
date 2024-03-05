# Neovim Config

<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/hosaka/nvim"><img src="https://dotfyle.com/hosaka/nvim/badges/plugin-manager?style=flat" /></a>

## Install

> Install requires Neovim 0.10+ (due to native snippets engine). Always review the code before installing a configuration.

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

  - neovim>=0.10 (nightly), git, [ripgrep](https://github.com/BurntSushi/ripgrep), [lazygit](https://github.com/jesseduffield/lazygit) (optional)

- **Optional**:
  - **Fonts**: A [Nerd Font](https://www.nerdfonts.com/).
  - **LSPs**: Language servers are not automatically installed, but can be with `:Mason`. See `nvim-lspconfig.lua` for a list of included settings.
  - **Linters**: When an LSP does not provide a linter, one can be installed with `:Mason`. See `nvim-lint.lua` for a list of included settings.
  - **Formatters**: When an LSP does not provide a formatter, one can be installed with `:Mason`. See `conform.lua` for a list of included settings.

## Plugins

Plugins are handled by the [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md) package manager. See `:h MiniDeps` for more details and `init.lua` for a list of installed plugins. Version hashes are stored in the `snapshot` file.

### colorscheme

- [folke/tokyonight.nvim](https://dotfyle.com/plugins/folke/tokyonight.nvim)

### completion

- [hrsh7th/nvim-cmp](https://dotfyle.com/plugins/hrsh7th/nvim-cmp)

### editing-support

- [windwp/nvim-ts-autotag](https://dotfyle.com/plugins/windwp/nvim-ts-autotag)
- [nvim-treesitter/nvim-treesitter-context](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-context)

### formatting

- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### git

- [lewis6991/gitsigns.nvim](https://dotfyle.com/plugins/lewis6991/gitsigns.nvim)
- [sindrets/diffview.nvim](https://dotfyle.com/plugins/sindrets/diffview.nvim)
- [NeogitOrg/neogit](https://dotfyle.com/plugins/NeogitOrg/neogit)

### indent

- [lukas-reineke/indent-blankline.nvim](https://dotfyle.com/plugins/lukas-reineke/indent-blankline.nvim)

### lsp

- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
- [mrcjkb/rustaceanvim](https://dotfyle.com/plugins/mrcjkb/rustaceanvim)
- [mfussenegger/nvim-lint](https://dotfyle.com/plugins/mfussenegger/nvim-lint)
- [b0o/SchemaStore.nvim](https://dotfyle.com/plugins/b0o/SchemaStore.nvim)

### lsp-installer

- [williamboman/mason.nvim](https://dotfyle.com/plugins/williamboman/mason.nvim)

### nvim-dev

- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)

### syntax

- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)
- [nvim-treesitter/nvim-treesitter-textobjects](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-textobjects)

### utility

- [stevearc/dressing.nvim](https://dotfyle.com/plugins/stevearc/dressing.nvim)
- [echasnovski/mini.nvim](https://dotfyle.com/plugins/echasnovski/mini.nvim)

## Language Servers

- astro
- html
- lua_ls
- marksman
- svelte

## Todo

### Editor

- [ ] Keep quickfix in focus when navigating items, until closed with `q`
- [ ] Try setting up [nvim-dap](https://github.com/mfussenegger/nvim-dap) for some LSPs
- [ ] Make use of some opensource code assistance ([ollama](https://ollama.ai))
- [ ] Replace tokyonight colorscheme with a base16 generated one

### Repo

- [ ] Setup [pre-commit](https://pre-commit.com/) hooks
