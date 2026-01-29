return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
    end,
  },
  {"rebelot/kanagawa.nvim"},

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        --theme = "tokyonight",
        component_separators = '|',
        section_separators = '',
      },
    }
  },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
        },
        linehl = false, 
        numhl = false, 
      }
    },
}
