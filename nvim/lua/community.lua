if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- 1. Language Packs (LSP, Formatters, Debuggers)
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" },      -- Adds clangd and C++ support
  { import = "astrocommunity.pack.rust" },     -- Adds rust-analyzer and Rust support

  -- 2. Tmux & Navigation
  -- This allows seamless navigation between Neovim splits and Tmux panes
  { import = "astrocommunity.motion.nvim-tmux-navigation" },

  -- 3. UI Enhancements (Optional but highly recommended for C++/Rust)
  { import = "astrocommunity.diagnostics.trouble-nvim" }, -- Better list for code errors
}
