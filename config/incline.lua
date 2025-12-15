require("incline").setup({
  window = {
    padding = 0,
    margin = { horizontal = 0, vertical = 0 },
  },
  render = function(props)
    local function get_filename()
      local mini_icons = require("mini.icons")
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
      if filename == "" then
        filename = "[no name]"
      end
      local ft_icon, ft_color = mini_icons.get("file", filename)
      local modified = vim.bo[props.buf].modified
      return {
        " ",
        { filename, gui = modified and "bold,italic" or "bold" },
        " ",
        ft_icon and { ft_icon, " ", guibg = "none", group = ft_color } or "",
      }
    end

    return {
      { get_filename() },
      group = props.focused and "ColorColumn" or "SignColumn",
    }
  end,
})
