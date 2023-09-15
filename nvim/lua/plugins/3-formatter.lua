return {
  -- Custom formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local null_ls_status_ok, null_ls = pcall(require, "null-ls")
      if not null_ls_status_ok then
        return
      end

      local b = null_ls.builtins

      local sources = {
        -- for tailwindcss
        b.formatting.rustywind.with({
          filetypes = { "html", "css", "javascriptreact", "typescriptreact", "svelte" },
        }),
        -- lua
        b.formatting.stylua,
      }
      return {
        require("null-ls").setup({
          sources = {
            {
              name = "prettier",
              filetypes = { "javascript", "typescript", "css", "html", "json" },
            },
          },
        }),
      }
    end,
  },
}
