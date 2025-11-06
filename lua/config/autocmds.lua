-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- use https://neovimcraft.com/plugin/okuuva/auto-save.nvim/index.html instead for a debounce feature
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--   pattern = { "*" },
--   command = "silent! wall",
--   nested = true,
-- })

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "markdown" },
--   callback = function()
--     vim.wo.conceallevel = 0
--   end,
-- })

local api = vim.api
local fn = vim.fn

-- Helper to copy text to system clipboard
local function copy_to_clipboard(text)
  if fn.has("mac") == 1 then
    fn.setreg("+", text)
  else
    fn.setreg("+", text)
  end
  vim.notify("Copied to clipboard: " .. text, vim.log.levels.INFO)
end

-- Copy file name (basename)
api.nvim_create_user_command("CopyFileName", function()
  local fname = fn.expand("%:t")
  if fname == "" then
    vim.notify("No file name", vim.log.levels.WARN)
    return
  end
  copy_to_clipboard(fname)
end, { nargs = 0 })

-- Copy full file path
api.nvim_create_user_command("CopyFilePath", function()
  local fpath = fn.expand("%:p")
  if fpath == "" then
    vim.notify("No file path", vim.log.levels.WARN)
    return
  end
  copy_to_clipboard(fpath)
end, { nargs = 0 })

-- Copy file parent directory
api.nvim_create_user_command("CopyFileDirectory", function()
  local fpath = fn.expand("%:p:h")
  if fpath == "" then
    vim.notify("No file path", vim.log.levels.WARN)
    return
  end
  copy_to_clipboard(fpath)
end, { nargs = 0 })
