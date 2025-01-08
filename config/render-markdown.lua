require("render-markdown").setup({
  render_modes = { "n", "i", "c" },
  file_types = { "markdown", "Avante" },
})

Hosaka.toggle({
  name = "markdown",
  get = function()
    return require("render-markdown.state").enabled
  end,
  set = function(state)
    if state then
      require("render-markdown").enable()
    else
      require("render-markdown").disable()
    end
  end,
}):mapl("om")
