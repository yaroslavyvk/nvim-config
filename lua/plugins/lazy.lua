-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Fixes Notify opacity issues
vim.o.termguicolors = true

require('lazy').setup({
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
      view = {
        width = 30,                 -- Ширина дерева
        side = "left",              -- Бок відкриття (left/right)
        preserve_window_proportions = true,
        float = {
          enable = true,            -- Відображати як спливаюче вікно
          open_win_config = {
            border = "rounded",     -- Округлі краї вікна
            width = 40,             -- Розширюємо ширину спливаючого вікна
            height = 30,
            row = 2,
            col = 2,
          },
        },
      },
      renderer = {
        group_empty = true,         -- Групувати порожні папки
        highlight_git = true,       -- Підсвічувати зміни Git
        icons = {
          show = {
            folder = true,
            file = true,
            git = true,
          },
          glyphs = {
            default = "",
            git = {
              unstaged  = "",
              staged    = "",
              unmerged  = "",
              renamed   = "",
              untracked = "ﲉ",
              deleted   = "",
              ignored   = "◌",
            },
            folder = {
              arrow_open   = "",
              arrow_closed = "",
              default      = "",
              open         = "",
              empty        = "",
              empty_open   = "",
              symlink      = "",
              symlink_open = "",
            },
          },
        },
      },
      git = {
        enable = true,
        ignore = false,             -- Показувати файли з .gitignore
      },
      filters = {
        dotfiles = false,           -- Якщо true, ховає файли з крапкою (.)
      },
      update_focused_file = {
        enable = true,              -- Фокус у дереві слідує за поточним файлом
        update_cwd = true,
      },
    })
      vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })
        -- Додаткові гарячі клавіші для швидкого переходу між вікнами
      vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Go to left window (Tree)" })
      vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Go to right window" })
    end
  },

  { 'echasnovski/mini.nvim', version = false },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
      {
        "]]",
        function() Snacks.words.jump(vim.v.count1) end,
        desc = "Next Reference",
        mode = { "n", "t" }
      },
      {
        "[[",
        function() Snacks.words.jump(-vim.v.count1) end,
        desc = "Prev Reference",
        mode = { "n", "t" }
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      Snacks = require("snacks")
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
          }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", {
            off = "light",
            on = "dark",
            name = "Dark Background"
          }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },

  {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    opts = {},
    name = 'render-markdown',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    }
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  {
    "mistricky/codesnap.nvim",
    build = "make",
  },

  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true
  },

  'onsails/lspkind.nvim',

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  "preservim/vim-pencil",

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  'folke/zen-mode.nvim',
  'tpope/vim-obsession',
  'ThePrimeagen/git-worktree.nvim',

  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        width = 120,
        height = 15,
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
        default_mappings = true,
        debug = false,
        opacity = nil,
        resizing_mappings = false,
        post_open_hook = nil,
        references = {
          telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
        },
        focus_on_open = true,
        dismiss_on_move = false,
        force_close = true,
        bufhidden = "wipe",
        stack_floating_preview_windows = true,
        preview_window_title = { enable = true, position = "left" },
      }
    end
  },

  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end
  },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },

  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d fewer lines' },
                { find = '%d more lines' },
              },
            },
            opts = { skip = true },
          }
        },
      	views = {
          cmdline_popup = {
      -- зразок: зробити дуже великий таймаут
            timeout = 999999, -- або 0, якщо підтримується, щоб не зникало
            },
          popup = {
            timeout = 999999,
            },
          mini = {
            timeout = 999999,
          },
  	},
})
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },

  -- ───────────────────────────────────────────────────────────────────
  -- Go-related plugins (REMOVED because you don't need them)
  -- 'ray-x/go.nvim',
  -- 'ray-x/guihua.lua',
  -- 'leoluz/nvim-dap-go',
  -- ───────────────────────────────────────────────────────────────────

  { "catppuccin/nvim", as = "catppuccin" },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
    }
  },

  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup({
        view = {
          entries = "native"
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
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
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = "neorg" },
        },
      })
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    }
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
  },
  'theHamsta/nvim-dap-virtual-text',

  -- Git related plugins
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',

  'nvim-lualine/lualine.nvim', -- Fancier statusline
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  'nvim-telescope/telescope-symbols.nvim',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = (vim.fn.executable 'make' == 1),
  },

  {
    "folke/twilight.nvim",
    ft = "markdown",
    opts = {
      -- Your Twilight config (if any)
    }
  },

})
