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

opt.title = true
opt.titlestring = "%t %m%r - nvim"

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.opt.title = false
  end,
})

-- ==========================================================================
-- 1. KEYMAPS BASE
-- ==========================================================================
vim.g.mapleader = ","

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move right" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clean search" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Clipboard safe
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "safe paste" })

-- ==========================================================================
-- 2. VIM-PLUG
-- ==========================================================================
local data_dir = vim.fn.stdpath('data')
local plug_path = data_dir .. '/site/autoload/plug.vim'

if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
  print("vim-plug...")
  vim.fn.system({
    'curl', '-fLo', plug_path, '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  })
  vim.cmd([[autocmd VimEnter * PlugInstall | source $MYVIMRC]])
end

local Plug = vim.fn['plug#']
vim.call('plug#begin', data_dir .. '/plugged')

-- LSP and autocompletion
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')

-- Utils
Plug('windwp/nvim-autopairs')
Plug('nvim-lualine/lualine.nvim')
Plug("ellisonleao/gruvbox.nvim")
-- FZF (Search)
Plug('junegunn/fzf')
Plug('junegunn/fzf.vim')

vim.call('plug#end')

-- ==========================================================================
-- 3. PLUGINS CONFIGURATION AND FZF
-- ==========================================================================
-- colorscheme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])
-- FZF
vim.keymap.set("n", "<leader>f", ":Files<CR>", { desc = "finder" })
vim.keymap.set("n", "<leader>b", ":Buffers<CR>", { desc = "list the open Buffers" })
vim.keymap.set("n", "<leader>s", ":Rg<CR>", { desc = "search text in files" })

-- Autopairs
local ap_status, autopairs = pcall(require, "nvim-autopairs")
if ap_status then
    autopairs.setup({})
end

-- nvim-cmp
local cmp_status, cmp = pcall(require, "cmp")
if cmp_status then
  cmp.setup({
    mapping = {
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-Space>'] = cmp.mapping.complete(),
    },
    sources = { { name = 'nvim_lsp' } }
  })
end

-- lualine
local lualine_status, lualine = pcall(require, "lualine")
if lualine_status then
  lualine.setup({ options = { icons_enabled = false, theme = 'auto' } })
end

-- diagnostics
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  signs = true,
  underline = true,
  update_in_insert = false,
  float = false,
})
-- ==========================================================================
-- 4. LSP 
-- ==========================================================================
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_lsp_status then
    capabilities = cmp_nvim_lsp.default_capabilities()
end

-- C / C++ 
vim.lsp.config.clangd = vim.tbl_deep_extend('force', vim.lsp.config.clangd or {}, {
  capabilities = capabilities,
  cmd = { "clangd", "--background-index" },
})
vim.lsp.enable("clangd")

-- Lua
vim.lsp.config.lua_ls = vim.tbl_deep_extend('force', vim.lsp.config.lua_ls or {}, {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = {'vim'} },
      workspace = { checkThirdParty = false },
    }
  }
})
vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.setloclist, opts)

  end,
})
