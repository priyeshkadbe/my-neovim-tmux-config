return {
  -- Add codeium, make sure that you ran :Codeium Auth after installation.
  -- {
  --   "Exafunction/codeium.vim",
  --   config = function()
  --     vim.keymap.set("i", "<Tab>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true })
  --     vim.keymap.set("i", "<C-j>", function()
  --       return vim.fn["codeium#CycleCompletions"](1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<C-k>", function()
  --       return vim.fn["codeium#CycleCompletions"](-1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-x>", function()
  --       return vim.fn["codeium#clear"]()
  --     end, { expr = true })
  --   end,
  -- },
  -- Disable default <tab> and <s-tab> behavior in LuaSnip
  --
  {
    "neovim/nvim-lspconfig",
    dependencies = { "folke/neodev.nvim" },
    config = function()
      -- Setup neovim lua configuration
      require("neodev").setup()
      -- require all language server modules
      require("servers.typescript")
      require("servers.eslint")
      require("servers.vue")
      require("servers.css")
      require("servers.html")
      require("servers.luals")
      require("servers.python")
      require("servers.json")
      require("servers.tailwind")
      require("servers.yaml")
      require("servers.prisma")
      require("servers.emmet")
      require("servers.gql")
      require("servers.rust")
      require("servers.go")
      require("servers.deno")
      require("servers.astro")
      require("servers.java")
      require("servers.markdown")

      -- rounded border on :LspInfo
      require("lspconfig.ui.windows").default_options.border = "rounded"

      -- Customization and appearance -----------------------------------------
      -- change gutter diagnostic symbols
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
        virtual_text = {
          source = "if_many",
          prefix = " ", -- Could be '●', '▎', 'x'
        },
        float = {
          source = "always",
        },
        severity_sort = true,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
    end,
  },
  {

    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-cmdline",      -- command line
      "hrsh7th/cmp-buffer",       -- buffer completions
      "hrsh7th/cmp-nvim-lua",     -- nvim config completions
      "hrsh7th/cmp-nvim-lsp",     -- lsp completions
      "hrsh7th/cmp-path",         -- file path completions
      "saadparwaiz1/cmp_luasnip", -- snippets completions
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind-nvim",
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true }, -- tailwind color in suggesions
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")

      local lspkind = require("lspkind")
      local luasnip = require("luasnip")

      -- html snippets in javascript and javascriptreact
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("typescriptreact", { "html" })

      local loader = require("luasnip/loaders/from_vscode")
      loader.lazy_load()

      -- load snippets from path/of/your/nvim/config/my-cool-snippets
      loader.lazy_load({ paths = { "./snippets" } })

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            ellipsis_char = "...",
            maxwidth = 50,
            before = function(entry, vim_item)
              vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
              return vim_item
            end,
          }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = {
          -- native_menu = false,
          ghost_text = true,
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
      })

      -- only enable nvim_lsp in lua files
      vim.cmd(
        [[ autocmd FileType lua lua require'cmp'.setup.buffer { sources = { { name = 'buffer' },{ name = 'nvim_lua'},{name = "nvim_lsp"}},} ]]
      )

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Add TabNine support, make sure you ran :CmpTabnineHub after installation.
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        dependencies = "hrsh7th/nvim-cmp",
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      local sources = {
        { name = "cmp_tabnine" },
      }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, sources))

      -- opts.formatting = {
      --   format = function(entry, vim_item)
      --     local icons = require("lazyvim.config").icons.kinds
      --     if icons[vim_item.kind] then
      --       vim_item.kind = icons[vim_item.kind] .. vim_item.kind
      --     end
      --
      --     -- Add tabnine icon and hide percentage in the menu
      --     if entry.source.name == "cmp_tabnine" then
      --       vim_item.kind = " [TabNine]"
      --       vim_item.menu = ""
      --
      --       if (entry.completion_item.data or {}).multiline then
      --         vim_item.kind = vim_item.kind .. " " .. "[ML]"
      --       end
      --     end
      --
      --     local maxwidth = 80
      --     vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
      --
      --     return vim_item
      --   end,
      -- }

      -- Disable ghost text for copilot/codium completions
      opts.experimental = {
        ghost_text = false,
      }

      -- add Ctrl-n and Ctrl-p to navigate through the completion menu
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-n>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  -- Add Codeium status to lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, {
        function()
          return vim.fn["codeium#GetStatusString"]()
        end,
      })
    end,
  },
  -- Jsdoc
  {
    "heavenshell/vim-jsdoc",
    ft = "javascript,typescript,typescriptreact,svelte",
    cmd = "JsDoc",
    keys = {
      { "<leader>jd", "<cmd>JsDoc<cr>", desc = "JsDoc" },
    },
    build = "make install",
  },
  -- Add Tailwind CSS LSP
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        -- rustywind for tailwindcss
        "tailwindcss-language-server",
        "rustywind",
        "tsserver",
        "volar",
        "tailwindcss",
        "cssls",
        "yamlls",
        "prismals",
        "emmet_ls",
        "graphql",
        "astro",
        "lua_ls",
        "pyright",
        "denols",
        "rust_analyzer",
        "gopls",
        "jdtls",
        "eslint",
        "jsonls",
        "marksman",
        "html",
        "clangd"
      },
      automatic_installation = true,
    },
  },

  {
    "prabirshrestha/vim-lsp",
  },
  {
    "leafOfTree/vim-matchtag",
    config = function()
      vim.g.vim_matchtag_enable_by_default = 1
      vim.g.vim_matchtag_files = "*.astro,*.html,*.xml,*.js,*.jsx,*.vue,*.svelte,*.jsp,*.tsx"
      vim.g.vim_matchtag_highlight_cursor_on = 1
    end,
  },
  {
    "windwp/nvim-autopairs",
    -- "simonward87/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "mbbill/undotree",
    config = function()
      vim.cmd([[
        if has("persistent_undo")
           let target_path = expand('~/.undodir')
            " create the directory and any parent directories
            " if the location does not exist.
            if !isdirectory(target_path)
                call mkdir(target_path, "p", 0700)
            endif
            let &undodir=target_path
            set undofile
        endif
        ]])
    end,
  },
  -- {
  --   "joshdick/onedark.vim",
  --
  --   config=function()
  --     vim.cmd("colorscheme onedark")
  --   end,
  -- }
  -- {
  --    "folke/tokyonight.nvim",
  --   config=function()
  --     vim.cmd("colorscheme tokyonight-night")
  --   end,
  -- lazy = false,
  -- priority = 1000,
  -- opts = {},
  -- }
  --
  --
  -- {
  --     "catppuccin/nvim",
  --     -- lazy = false,
  --     -- name = "catppuccin",
  --     -- you can do it like this with a config function
  --     config = function()
  --         vim.cmd("colorscheme catppuccin")
  --     end,
  --   },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "catppuccin",
  --   },
  -- },
  {
    "maxmx03/dracula.nvim",
    config = function()
      vim.cmd.colorscheme "dracula"
    end
  }
}
