-- General config
local opt = vim.opt

-- --- Visual ---
opt.number = true           
opt.relativenumber = false  
opt.signcolumn = "yes"      -- Mantiene espacio fijo a la izq para evitar saltos visuales (git/lsp)
opt.termguicolors = true    -- Colors 24-bits
opt.cursorline = true       
opt.wrap = false           

-- --- Indentación (4 espacios estándar) ---
opt.tabstop = 4             -- Tamaño visual del tab
opt.shiftwidth = 4          -- Tamaño de indentación automática
opt.expandtab = true        -- Convierte tabs a espacios (obligatorio en Python/Lua etc)
opt.smartindent = true      -- Indentación inteligente

-- --- Búsqueda ---
opt.ignorecase = true      
opt.smartcase = true        
opt.hlsearch = true       

-- --- Usabilidad ---
opt.scrolloff = 8           -- Mantiene 8 líneas de margen al hacer scroll (el cursor no toca el borde)
opt.sidescrolloff = 8       -- Lo mismo para scroll lateral
opt.mouse = "a"             -- Habilita soporte de ratón
opt.clipboard = "unnamedplus" -- Sincroniza con el portapapeles del sistema (Ctrl+C / Ctrl+V externos funcionan)
opt.updatetime = 50         -- Reduce el tiempo de escritura a disco (swap) y eventos (hace la UI más rápida)
opt.splitbelow = true       -- Nuevos splits horizontales abajo
opt.splitright = true       -- Nuevos splits verticales a la derecha


-- Keymaps
vim.g.mapleader = ","
-- Simplificar guardado y salir
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Guardar archivo" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Salir" })

-- Moverse entre ventanas (Splits) usando Ctrl + hjkl en lugar de Ctrl+w + hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Ir a ventana abajo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Ir a ventana arriba" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

-- Limpiar resaltado de búsqueda con ESC
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado" })

-- Mantener el cursor centrado al hacer scroll rápido
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Mejor indentación en modo visual (no pierdes la selección al indentar)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Clipboard
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Pegar Safe" })

-- PLUGINS KEYMAPS
-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = 'Telescope find files' })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = 'Telescope live grep' })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = 'Telescope buffers' })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = 'Telescope help tags' })

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Panel de Errores" })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Errores (Buffer)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Referencias/Definiciones" })

-- Import plugins modules
require("config.lazy")
vim.lsp.enable('julials')
