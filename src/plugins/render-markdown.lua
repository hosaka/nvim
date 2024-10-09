require("render-markdown").setup({
  render_modes = { "n", "i", "c" },
  file_types = { "markdown", "Avante" },
})

local nmap_toggle = Hosaka.toggle.map

nmap_toggle("om", {
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
})
