local minivisits = require("mini.visits")
minivisits.setup()

local minipick = require("mini.pick")

local function pick_visit_labels(opts)
  local picker_opts = {
    mappings = {
      delete_label = {
        char = "<C-d>",
        func = function()
          local matches = minipick.get_picker_matches()
          if matches then
            if next(matches.marked) then
              for _, label in ipairs(matches.marked) do
                minivisits.remove_label(label)
              end
            elseif matches.current then
              minivisits.remove_label(matches.current)
            end
            pick_visit_labels(opts)
          end
        end,
      },
    },
  }
  return require("mini.extra").pickers.visit_labels(opts, picker_opts)
end

minipick.registry.visit_labels = pick_visit_labels

local iterate_visits = function(label, direction)
  return function()
    minivisits.iterate_paths(direction, vim.fn.getcwd(), { filter = label, recency_weight = 0, wrap = true })
  end
end

local function pick_visits(opts)
  local cwd = opts.cwd
  local label = opts.label
  local picker_opts = {
    source = {
      name = string.format("%s visits (%s)", label, cwd ~= "" and "cwd" or "all"),
    },
    mappings = {
      delete_visit = {
        char = "<C-d>",
        func = function()
          local matches = minipick.get_picker_matches()
          if matches then
            if next(matches.marked) then
              for _, marked in ipairs(matches.marked) do
                minivisits.remove_label(label, marked, cwd)
              end
            elseif matches.current then
              minivisits.remove_label(label, matches.current, cwd)
            end
            pick_visits(opts)
          end
        end,
      },
    },
  }
  return require("mini.extra").pickers.visit_paths({ cwd = cwd, filter = label, recency_weight = 0 }, picker_opts)
end

minipick.registry.visits = pick_visits

local map = Hosaka.keymap.map

map("]]", iterate_visits("core", "forward"), { desc = "Core forward" })
map("[[", iterate_visits("core", "backward"), { desc = "Core backward" })
