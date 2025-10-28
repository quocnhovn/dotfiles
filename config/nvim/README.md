# LazyVim IDE Configuration for Deepin OS 25

🚀 Professional Neovim configuration based on **lazy-nvim-ide** by jellydn, customized for fullstack development on Deepin OS 25.

## ✨ Features

### 🔧 Development Languages
- **PHP**: Laravel, Symfony, CodeIgniter with Intelephense LSP
- **Go**: Full toolchain with gopls, debugging, and testing
- **Vue.js/TypeScript**: Modern frontend development with Volar
- **Python**: Development support with proper LSP
- **HTML/CSS**: Web development essentials
- **Docker**: Container development support

### 🛠️ Enhanced IDE Features
- **LazyVim Base**: Professional Neovim distribution
- **LSP Integration**: Auto-completion, diagnostics, formatting
- **Debugging (DAP)**: Multi-language debugging support
- **Project Management**: Session persistence, project switching
- **Database UI**: Built-in database management
- **Git Integration**: Enhanced Git workflow
- **Terminal Integration**: Seamless terminal experience
- **File Management**: Neo-tree with enhanced navigation

### 🎨 UI/UX Enhancements
- **Tokyo Night Theme**: Eye-friendly dark theme optimized for Deepin OS
- **Alternative Themes**: Catppuccin, Dracula available
- **Enhanced Status Line**: Development-focused information
- **Which-Key**: Discoverable keybindings
- **Telescope**: Fuzzy finding everything
- **FZF Integration**: Ultra-fast search

## 🚀 Quick Start

### Installation
The configuration is automatically installed with the main dotfiles:
```bash
cd ~/.dotfiles
./install.sh
```

### First-time Setup
After installation, run the first-time setup:
```bash
/tmp/nvim-first-setup.sh
```

### Verify Installation
```bash
nvim
:checkhealth
```

## ⌨️ Key Bindings

### 🔧 Development Workflow
| Key          | Action          | Description             |
| ------------ | --------------- | ----------------------- |
| `<leader>?`  | Show help       | Display all keybindings |
| `<leader>ps` | Switch project  | Project management      |
| `<leader>tt` | Toggle terminal | Integrated terminal     |
| `<leader>e`  | File explorer   | Toggle Neo-tree         |

### 🐞 Debugging
| Key          | Action            | Description              |
| ------------ | ----------------- | ------------------------ |
| `<F5>`       | Continue          | Start/continue debugging |
| `<F10>`      | Step over         | Debug step over          |
| `<F11>`      | Step into         | Debug step into          |
| `<F12>`      | Step out          | Debug step out           |
| `<leader>db` | Toggle breakpoint | Set/remove breakpoint    |

### 🗄️ Database Management
| Key          | Action      | Description               |
| ------------ | ----------- | ------------------------- |
| `<leader>Dt` | Database UI | Toggle database interface |
| `<leader>Df` | Find buffer | Find database buffer      |

### 📝 Language-Specific

#### PHP/Laravel
| Key          | Action  | Description               |
| ------------ | ------- | ------------------------- |
| `<leader>la` | Artisan | Laravel artisan commands  |
| `<leader>lr` | Routes  | Show Laravel routes       |
| `<leader>lm` | Make    | Create Laravel components |

#### Go Development
| Key          | Action    | Description          |
| ------------ | --------- | -------------------- |
| `<leader>gt` | Go test   | Run Go tests         |
| `<leader>gr` | Go run    | Run Go application   |
| `<leader>gb` | Go build  | Build Go application |
| `<leader>gf` | Go format | Format Go code       |

---

🎯 **Happy Coding!** This LazyVim IDE configuration is optimized for productive fullstack development on Deepin OS 25.

## Install Neovim

The easy way is using [MordechaiHadad/bob: A version manager for neovim](https://github.com/MordechaiHadad/bob).

```sh
bob install stable
bob use stable
```

## Install the config

Make sure to remove or move your current `nvim` directory

```sh
git clone https://github.com/jellydn/lazy-nvim-ide.git ~/.config/nvim
```

Or use the following command to install the config:

```sh
git clone https://github.com/jellydn/lazy-nvim-ide.git ~/.config/lazyvim
alias lvim="NVIM_APPNAME=lazyvim nvim"
```


Run `nvim` and wait for the plugins to be installed

## Get healthy

Open `nvim` and enter the following:

```lua
:checkhealth
```

## Fonts

I recommend using the following repo to get a "Nerd Font" (Font that supports icons)

[getnf](https://github.com/ronniedroid/getnf)

## Try with Docker

```sh
docker run -w /root -it --rm alpine:latest sh -uelic '
  apk add git nodejs npm neovim ripgrep build-base make musl-dev go --update
  go install github.com/jesseduffield/lazygit@latest
  git clone https://github.com/jellydn/lazy-nvim-ide ~/.config/nvim
  nvim
  '
```

## Uninstall

```sh
  rm -rf ~/.config/nvim
  rm -rf ~/.local/share/nvim
  rm -rf ~/.cache/nvim
  rm -rf ~/.local/state/nvim
```

## Screenshots

<img width="1792" alt="image" src="https://user-images.githubusercontent.com/870029/228557089-0faaa49f-5dab-4704-a919-04decfc781ac.png">

## Tips

- Improve key repeat on Mac OSX, need to restart

```sh
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 14
```

- VSCode on Mac

To enable key-repeating, execute the following in your Terminal, log out and back in, and then restart VS Code:

```sh
# For VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
# For VS Code Insider
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
# If necessary, reset global default
defaults delete -g ApplePressAndHoldEnabled
# For Cursor
defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false
```

Also increasing Key Repeat and Delay Until Repeat settings in System Preferences -> Keyboard.

[![Key repeat rate](https://i.gyazo.com/e58be996275fe50bee31412ea5930017.png)](https://gyazo.com/e58be996275fe50bee31412ea5930017)

## Resources

[![IT Man - Talk #33 NeoVim as IDE [Vietnamese]](https://i.ytimg.com/vi/dFi8CzvqkNE/hqdefault.jpg)](https://www.youtube.com/watch?v=dFi8CzvqkNE)

[![IT Man - Talk #35 #Neovim IDE for Web Developer](https://i.ytimg.com/vi/3EbgMJ-RcWY/hqdefault.jpg)](https://www.youtube.com/watch?v=3EbgMJ-RcWY)

[![IT Man - Step-by-Step Guide: Integrating Copilot Chat with Neovim [Vietnamese]](https://i.ytimg.com/vi/By_CCai62JE/hqdefault.jpg)](https://www.youtube.com/watch?v=By_CCai62JE)

[![IT Man - Power up your Neovim with Gen.nvim](https://i.ytimg.com/vi/2nt_qcchW_8/hqdefault.jpg)](https://www.youtube.com/watch?v=2nt_qcchW_8)

[![IT Man - Boost Your Neovim Productivity with GitHub Copilot Chat](https://i.ytimg.com/vi/6oOPGaKCd_Q/hqdefault.jpg)](https://www.youtube.com/watch?v=6oOPGaKCd_Q)

[![IT Man - Get to know GitHub Copilot Chat in #Neovim and be productive IMMEDIATELY](https://i.ytimg.com/vi/sSih4khcstc/hqdefault.jpg)](https://www.youtube.com/watch?v=sSih4khcstc)

[![IT Man - Enhance Your Neovim Experience with LSP Plugins](https://i.ytimg.com/vi/JwWNIQgL4Fk/hqdefault.jpg)](https://www.youtube.com/watch?v=JwWNIQgL4Fk)
