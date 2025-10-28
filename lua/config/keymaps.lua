-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<Esc>")

function ToggleTerminal(cwd)
  cwd = cwd or LazyVim.root()
  -- expand to absolute path to ensure same terminal ID of same directory
  cwd = vim.fn.fnamemodify(cwd, ":p")
  Snacks.terminal({
    "pwsh.exe",
    "-NoExit",
    "-Command",
    [[&{Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell bcb9ea00 -SkipAutomaticLocation -DevCmdArguments """-arch=x64 -host_arch=x64"""}]],
  }, {
    cwd = cwd,
  })
end

vim.api.nvim_create_user_command("FTerm", ToggleTerminal, { desc = "Float Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<leader>ft", ToggleTerminal, { desc = "Float Terminal (Root Dir)", noremap = true })
vim.keymap.set({ "n", "t" }, "<leader>fT", function()
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  ToggleTerminal(dir)
end, { desc = "Float Terminal (file dir)", noremap = true })
vim.keymap.set({ "n", "t" }, "<c-\\>", ToggleTerminal, { desc = "Toggle Terminal", noremap = true })
