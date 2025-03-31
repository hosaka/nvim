require("avante").setup({
  provider = "openai",
  cursor_applying_provider = "groq",
  behaviour = {
    auto_suggestions = false,
    auto_set_keymaps = true,
    enable_cursor_planning_mode = true,
  },
  vendors = {
    groq = {
      __inherited_from = "openai",
      api_key_name = "GROQ_API_KEY",
      endpoint = "https://api.groq.com/openai/v1",
      model = "llama-3.3-70b-versatile",
      max_tokens = 32768,
    },
  },
  windows = {
    sidebar_header = {
      align = "right",
      rounded = false,
    },
  },
})
