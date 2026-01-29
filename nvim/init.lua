-- General config
local opt = vim.opt
-- --- Visual ---
opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.termguicolors = true    -- Colors 24-bits
opt.cursorline = true
opt.wrap = false

-- --- Indentation (4) ---
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true        -- tabs --> spaces
opt.smartindent = true

-- --- Search ---
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- --- Use ---
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"             -- mouse=yes
opt.clipboard = "unnamedplus" -- share clipboard
opt.updatetime = 50
opt.splitbelow = true
opt.splitright = true

vim.opt.title = true

vim.opt.titlestring = "%t %m%r - nvim" 

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.opt.title = false
  end,
})
-- Keymaps
vim.g.mapleader = ","

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clean" })


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Clipboard
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "safe paste" })

-- PLUGINS KEYMAPS
-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = 'Telescope find files' })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = 'Telescope live grep' })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = 'Telescope buffers' })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = 'Telescope help tags' })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "errors panel" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Errors (Buffer)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP References/definition" })

-- Import plugins modules
require("config.lazy")
vim.cmd("colorscheme kanagawa")
