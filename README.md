# My Neovim & Tmux Setup 

A high-performance, aesthetic development environment for macOS. This repository centralizes my configurations for **AstroNvim** and **Tmux**, specifically optimized for C++ development and a seamless terminal-based workflow.

---

## 📦 What's Inside?

* **Neovim (`/nvim`)**: A full AstroNvim configuration with LSP support (clangd), Treesitter for syntax highlighting, and the Tokyonight color scheme.
* **Tmux (`.tmux.conf`)**: A productivity-focused multiplexer config featuring a custom `Ctrl-a` prefix, optimized pane management, and smart navigation.

---

## 🛠️ Installation & Setup

### 1. Install Core Dependencies

Ensure you have [Homebrew](https://brew.sh/) installed, then run the following to install the necessary tools:
```bash
brew install neovim tmux git
```

### 2. Configure Neovim (AstroNvim)

AstroNvim acts as the IDE engine. Follow these steps to apply my custom settings:
```bash
# 1. Backup any existing configuration
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Clone the official AstroNvim template
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim

# 3. Copy my custom configuration into the nvim directory
cp -r ~/my-neovim-tmux-config/nvim/* ~/.config/nvim/
```

*After copying, launch Neovim (`nvim`) and wait for the automated installer to download plugins and LSPs.*

### 3. Configure Tmux

To enable the custom status bar, themes, and keybindings:

1. **Install Tmux Plugin Manager (TPM):**
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2. **Apply the configuration file:**
```bash
cp ~/my-neovim-tmux-config/.tmux.conf ~/
```

3. **Install Plugins:**

Open `tmux`, then press `Ctrl + a` followed by `I` (capital I) to fetch and install the plugins listed in the config.

---

## ⌨️ Workflow & Shortcuts

### Tmux Navigation

The prefix is remapped to **`Ctrl + a`** for easier access.

* **Vertical Split**: `Prefix` + `|`
* **Horizontal Split**: `Prefix` + `-`
* **Smart Pane Navigation**: Use `Ctrl + h/j/k/l` to move seamlessly between Tmux panes and Neovim windows.
* **Zoom Pane**: `Prefix` + `z` to toggle full-screen for the active pane.
