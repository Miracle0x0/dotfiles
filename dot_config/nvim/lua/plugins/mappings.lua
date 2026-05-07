return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- first key is the mode
        n = {
          -- second key is the lefthand side of the map
          -- mappings seen under group name "Buffer"
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(
                function(bufnr) require("astrocore.buffer").close(bufnr) end
              )
            end,
            desc = "Pick to close",
          },
          -- tables with just a `desc` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          ["<Leader>b"] = { desc = "Buffers" },
          -- quick save
          ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command
          ["<Leader>ro"] = { ":set ro!<cr>", desc = "Toggle Read-Only" },

          --- open terminal
          -- ["<Leader>tt"] = { "<cmd>terminal<cr>", desc = "Open Terminal" },
          -- ["<Leader>t|"] = { "<cmd>vsplit | terminal<cr>", desc = "Open Terminal (Vertical)" },
          -- ["<Leader>t-"] = { "<cmd>split | terminal<cr>", desc = "Open Terminal (Horizontal)" },
          ["<Leader>tt"] = {
            -- function()
            --   vim.cmd("terminal")
            --   vim.cmd("startinsert")
            -- end,
            "<cmd>term<cr>A",
            -- function()
            --   vim.cmd("ToggleTerm direction=tab")
            -- end,
            desc = "Terminal (New Tab)",
            -- desc = "ToggleTerm (New Tab)"
          },
          ["<Leader>t|"] = {
            -- function()
            --   vim.cmd("vsplit")
            --   vim.cmd("terminal")
            --   vim.cmd("startinsert")
            -- end,
            "<cmd>vsplit | term<cr>A",
            -- "<cmd>ToggleTerm direction=vertical<cr>",
            -- function()
            --   local size = vim.o.columns * 0.5
            --   vim.cmd("ToggleTerm direction=vertical size=" .. size)
            -- end,
            desc = "Terminal (Vertical)",
          },
          ["<Leader>t-"] = {
            -- function()
            --   vim.cmd("split")
            --   vim.cmd("terminal")
            --   vim.cmd("startinsert")
            -- end,
            "<cmd>split | term<cr>A",
            -- "<cmd>ToggleTerm direction=horizontal<cr>",
            -- function()
            --   local size = vim.o.lines * 0.5
            --   vim.cmd("ToggleTerm direction=horizontal size=" .. size)
            -- end,
            desc = "Terminal (Horizontal)",
          },
          ["<Leader>md"] = {
            "<cmd>MarkliveToggle<cr>",
            desc = "Toggle markdown task",
          },
        },
        t = {
          -- setting a mapping to false will disable it
          -- ["<esc>"] = false,
          ["<esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      mappings = {
        n = {
          -- this mapping will only be set in buffers with an LSP attached
          K = {
            function() vim.lsp.buf.hover() end,
            desc = "Hover symbol details",
          },
          -- condition for only server with declaration capabilities
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
        },
      },
    },
  },
}
