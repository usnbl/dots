-- this config require cland, lua-language-serer, pandoc, git and curl
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
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')

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

-- nvim-cmp + LuaSnip
local cmp_status, cmp = pcall(require, "cmp")
local ls_status, luasnip = pcall(require, "luasnip")

if cmp_status and ls_status then
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = false }), 
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = { 
      { name = 'luasnip', priority = 1000 },
      { name = 'nvim_lsp' } 
    }
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

-- ==========================================================================
-- 5. markdown
-- ==========================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(event)
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 2
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "es,en"
    vim.keymap.set("n", "<leader>c", function()
      local file = vim.fn.expand("%:p")
      local out = vim.fn.expand("%:p:r") .. ".pdf"
      print("Pandoc: Compiling...")
      vim.fn.jobstart({"pandoc", file, "-o", out}, {
        on_exit = function(_, code)
          if code == 0 then print("OK: PDF ready") else print("Error") end
        end
      })
    end, { buffer = event.buf, desc = "Compilar Markdown a PDF" })
      end,
})

if ls_status then
  luasnip.add_snippets("markdown", {
    -- 1. basic md
    luasnip.parser.parse_snippet(";h1", "# $0"),
    luasnip.parser.parse_snippet(";h2", "## $0"),
    luasnip.parser.parse_snippet(";h3", "### $0"),
    luasnip.parser.parse_snippet(";mt", "$$\n$1\n$$ $0"),
    luasnip.parser.parse_snippet(";cd", "```$1\n$2\n``` $0"),
    luasnip.parser.parse_snippet(";td", "- [ ] $0"),
    luasnip.parser.parse_snippet(";b", "**$1**$0"),
    luasnip.parser.parse_snippet(";i", "*$1*$0"),

    -- 2. Calculus and Algebra
    luasnip.parser.parse_snippet(";f", "\\\\frac{$1}{$2} $0"),
    luasnip.parser.parse_snippet(";in", "\\\\int_{$1}^{$2} $3 \\, d$0"),
    luasnip.parser.parse_snippet(";iint", "\\\\iint_{$1} $0"),
    luasnip.parser.parse_snippet(";oint", "\\\\oint_{$1} $0"),
    luasnip.parser.parse_snippet(";lim", "\\\\lim_{${1:x} \\\\to ${2:\\\\infty}} $0"),
    luasnip.parser.parse_snippet(";sum", "\\\\sum_{${1:n=1}}^{${2:\\\\infty}} $0"),
    luasnip.parser.parse_snippet(";sq", "\\\\sqrt{$1} $0"),
    luasnip.parser.parse_snippet(";pr", "\\\\frac{\\\\partial $1}{\\\\partial $2} $0"),
    luasnip.parser.parse_snippet(";der", "\\\\frac{d$1}{d$2} $0"),
    luasnip.parser.parse_snippet(";vec", "\\\\vec{$1} $0"),
    luasnip.parser.parse_snippet(";hat", "\\\\hat{$1} $0"),
    luasnip.parser.parse_snippet(";mat", "\\\\begin{pmatrix} $1 \\\\end{pmatrix} $0"),
    luasnip.parser.parse_snippet(";cas", "\\\\begin{cases} $1 \\\\end{cases} $0"),
    luasnip.parser.parse_snippet(";gr", "\\\\nabla $0"),
    luasnip.parser.parse_snippet(";no", "\\\\| $1 \\\\| $0"),

    -- 3. logic
    luasnip.parser.parse_snippet(";el", "\\\\in $0"),
    luasnip.parser.parse_snippet(";nel", "\\\\notin $0"),
    luasnip.parser.parse_snippet(";fa", "\\\\forall $0"),
    luasnip.parser.parse_snippet(";ex", "\\\\exists $0"),
    luasnip.parser.parse_snippet(";->", "\\\\rightarrow $0"),
    luasnip.parser.parse_snippet(";=>", "\\\\Rightarrow $0"),
    luasnip.parser.parse_snippet(";mto", "\\\\mapsto $0"),
    luasnip.parser.parse_snippet(";iff", "\\\\iff $0"),
    luasnip.parser.parse_snippet(";ne", "\\\\neq $0"),
    luasnip.parser.parse_snippet(";ge", "\\\\geq $0"),
    luasnip.parser.parse_snippet(";le", "\\\\leq $0"),
    luasnip.parser.parse_snippet(";ap", "\\\\approx $0"),
    luasnip.parser.parse_snippet(";oo", "\\\\infty $0"),
    luasnip.parser.parse_snippet(";RR", "\\\\mathbb{R}"),
    luasnip.parser.parse_snippet(";NN", "\\\\mathbb{N}"),
    luasnip.parser.parse_snippet(";ZZ", "\\\\mathbb{Z}"),
    luasnip.parser.parse_snippet(";CC", "\\\\mathbb{C}"),
    luasnip.parser.parse_snippet(";sub", "\\\\subseteq $0"),
    luasnip.parser.parse_snippet(";and", "\\\\land $0"),
    luasnip.parser.parse_snippet(";or", "\\\\lor $0"),

    -- 4. ALFABETO GRIEGO (Física y Matemáticas)
    luasnip.parser.parse_snippet(";a", "\\\\alpha"),
    luasnip.parser.parse_snippet(";b", "\\\\beta"),
    luasnip.parser.parse_snippet(";g", "\\\\gamma"),
    luasnip.parser.parse_snippet(";G", "\\\\Gamma"),
    luasnip.parser.parse_snippet(";d", "\\\\delta"),
    luasnip.parser.parse_snippet(";D", "\\\\Delta"),
    luasnip.parser.parse_snippet(";e", "\\\\epsilon"),
    luasnip.parser.parse_snippet(";t", "\\\\theta"),
    luasnip.parser.parse_snippet(";T", "\\\\Theta"),
    luasnip.parser.parse_snippet(";l", "\\\\lambda"),
    luasnip.parser.parse_snippet(";m", "\\\\mu"),
    luasnip.parser.parse_snippet(";p", "\\\\pi"),
    luasnip.parser.parse_snippet(";r", "\\\\rho"),
    luasnip.parser.parse_snippet(";s", "\\\\sigma"),
    luasnip.parser.parse_snippet(";S", "\\\\Sigma"),
    luasnip.parser.parse_snippet(";o", "\\\\omega"),
    luasnip.parser.parse_snippet(";O", "\\\\Omega"),
    luasnip.parser.parse_snippet(";fi", "\\\\phi"),
    luasnip.parser.parse_snippet(";psi", "\\\\psi"),
  })
end
