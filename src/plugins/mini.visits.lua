local minivisits = require("mini.visits")
minivisits.setup()

local minipick = require("mini.pick")

local function pick_visits(label, cwd)
  return function()
    local miniextra = require("mini.extra")
    miniextra.pickers.visit_paths({
      cwd = cwd,
      filter = label,
      recency_weight = 0,
    }, {
      source = { name = string.format("%s visits (%s)", label, cwd ~= "" and "cwd" or "all") },
      mappings = {
        delete_visit = {
          char = "<C-d>",
          func = function()
            local matches = minipick.get_picker_matches()
            if matches and matches.current then
              minivisits.remove_label(label, matches.current, cwd)
            end
            pick_visits(label, cwd)()
          end,
        },
      },
    })
  end
end

local iterate_visits = function(label, direction)
  return function()
    minivisits.iterate_paths(direction, vim.fn.getcwd(), { filter = label, recency_weight = 0, wrap = true })
  end
end

local map = Hosaka.keymap.map
local mapl = Hosaka.keymap.mapl

map("]]", iterate_visits("core", "forward"), { desc = "Core forward" })
map("[[", iterate_visits("core", "backward"), { desc = "Core backward" })

mapl("vc", pick_visits("core", ""), { desc = "Core visits (all)" })
mapl("vC", pick_visits("core", nil), { desc = "Core visits (cwd)" })

mapl("va", function()
  vim.ui.input({ prompt = "Add label" }, function(input)
    if input then
      minivisits.add_label(input)
    end
  end)
end, { desc = "Add label" })
mapl("vr", function()
  -- todo: use mini.pick populated from mini.visits.list_labels
  -- to only list labels applicable to the current buffer, remove
  -- upon selecting one
  vim.ui.input({ prompt = "Remove label" }, function(input)
    if input then
      minivisits.remove_label(input)
    end
  end)
end, { desc = "Remove label" })
