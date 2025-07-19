function _G.reload_neovim_config()
  -- Clear package.loaded for your custom modules (adjust patterns as needed)
  local core_modules = {
    "user.*", -- Example: Matches modules like "user.settings", "user.keymaps"
    "plugins.*", -- Example: Matches plugin setup modules
    "config.*", -- Add other prefixes used in your config
  }

  for module, _ in pairs(package.loaded) do
    for _, pattern in ipairs(core_modules) do
      if module:match("^" .. pattern) then
        package.loaded[module] = nil
        break
      end
    end
  end

  -- Re-source the main configuration file
  local main_config = vim.env.MYVIMRC
  if vim.fn.filereadable(main_config) == 1 then
    vim.cmd.source(main_config)
    vim.notify("Neovim config reloaded!", vim.log.levels.INFO)
  else
    vim.notify("Config not found: " .. main_config, vim.log.levels.ERROR)
  end
end

-- Initialize tab history
vim.g.tab_history = {}

-- Track tab changes
vim.api.nvim_create_autocmd("TabLeave", {
  pattern = "*",
  callback = function()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local prev_tab = vim.g.tab_history[#vim.g.tab_history]

    -- Only record if we're not toggling between the same two tabs
    if current_tab ~= prev_tab then
      table.insert(vim.g.tab_history, current_tab)

      -- Keep only the last 2 entries
      if #vim.g.tab_history > 2 then
        table.remove(vim.g.tab_history, 1)
      end
    end
  end,
})

-- Toggle between last two tabs
function _G.toggle_tabs()
  if #vim.g.tab_history < 2 then
    vim.notify("Need at least 2 tabs in history", vim.log.levels.WARN)
    return
  end

  local current_tab = vim.api.nvim_get_current_tabpage()
  local last_tab = vim.g.tab_history[#vim.g.tab_history]
  local prev_tab = vim.g.tab_history[#vim.g.tab_history - 1]

  local target_tab = (current_tab == last_tab) and prev_tab or last_tab

  if vim.api.nvim_tabpage_is_valid(target_tab) then
    vim.api.nvim_set_current_tabpage(target_tab)
  else
    vim.notify("Target tab is no longer valid", vim.log.levels.ERROR)
  end
end

require("gabogg.core.options")
require("gabogg.core.keymaps")
