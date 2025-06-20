require("avante").setup({
  provider = "openai",
  cursor_applying_provider = "groq",
  behaviour = {
    auto_suggestions = false,
    auto_set_keymaps = true,
    enable_cursor_planning_mode = true,
  },
  providers = {
    openai = {
      endpoint = "https://api.openai.com/v1",
      api_key_name = "OPENAI_API_KEY",
      model = "gpt-4o",
      extra_request_body = {
        temperature = 0,
      },
    },
    groq = {
      __inherited_from = "openai",
      api_key_name = "GROQ_API_KEY",
      endpoint = "https://api.groq.com/openai/v1",
      model = "llama-3.3-70b-versatile",
      disable_tools = true,
      extra_request_body = {
        max_tokens = 32768,
      },
    },
  },
  windows = {
    sidebar_header = {
      align = "right",
      rounded = false,
    },
  },
})
