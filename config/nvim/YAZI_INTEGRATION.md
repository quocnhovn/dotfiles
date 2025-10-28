# Yazi Integration with LazyVim IDE

Yazi file manager đã được tích hợp hoàn toàn vào LazyVim IDE, thay thế oil.nvim để có trải nghiệm file management nhất quán với dotfiles.

## Tính năng chính

### 🚀 Thay thế Oil.nvim
- Yazi đã thay thế oil.nvim làm file manager mặc định
- Sử dụng cấu hình Yazi từ dotfiles chính (`~/.config/yazi`)
- Tích hợp mượt mà với ecosystem LazyVim

### ⌨️ Keybindings

| Phím tắt     | Chức năng         | Mô tả                                  |
| ------------ | ----------------- | -------------------------------------- |
| `<leader>e`  | Mở Yazi           | File manager chính (thay thế oil.nvim) |
| `<leader>E`  | Neo-tree          | File manager thay thế                  |
| `<leader>fy` | Yazi CWD          | Mở Yazi trong thư mục hiện tại         |
| `<leader>fY` | Yazi Current File | Mở Yazi với file hiện tại được chọn    |
| `<leader>ft` | Yazi + Telescope  | Tích hợp với Telescope                 |
| `<leader>fs` | Yazi + Spectre    | Tích hợp với Spectre (search/replace)  |

### 🔧 Tích hợp với LazyVim

#### Telescope Integration
```lua
-- Mở Yazi rồi chuyển sang Telescope với file được chọn
require("yazi").yazi(nil, nil, function(chosen_file)
  if chosen_file then
    require("telescope.builtin").find_files({
      default_text = vim.fn.fnamemodify(chosen_file, ":t"),
      cwd = vim.fn.fnamemodify(chosen_file, ":h"),
    })
  end
end)
```

#### Spectre Integration
```lua
-- Mở Yazi rồi chuyển sang Spectre trong thư mục được chọn
require("yazi").yazi(nil, nil, function(chosen_file)
  if chosen_file then
    local spectre = require("spectre")
    spectre.toggle({
      cwd = vim.fn.fnamemodify(chosen_file, ":h"),
    })
  end
end)
```

### 🔄 Auto-refresh
- Neo-tree tự động refresh khi Yazi thay đổi file/folder
- Terminal integration được tối ưu cho Yazi
- Tích hợp với Deepin File Manager (`<leader>of` trong Neo-tree)

## Cấu hình

### Plugin Configuration
File: `lua/plugins/yazi-integration.lua`
- Cấu hình plugin `mikavilpas/yazi.nvim`
- Disable oil.nvim
- Setup keybindings và integrations

### Yazi Setup
File: `lua/config/yazi-config.lua`
- Path configuration
- Keybindings setup
- LazyVim ecosystem integrations
- Autocmds cho better integration

### Deepin Integration
File: `lua/plugins/deepin-config.lua`
- Yazi config được load trong toggleterm setup
- Neo-tree integration với Deepin File Manager
- Terminal optimizations

## Workflow

### Development Workflow
1. **File Navigation**: `<leader>e` để mở Yazi
2. **File Search**: `<leader>ft` để search file với Telescope
3. **Search & Replace**: `<leader>fs` để search/replace với Spectre
4. **System Integration**: `<leader>of` trong Neo-tree để mở Deepin File Manager

### Best Practices
- Sử dụng Yazi cho file operations phức tạp
- Sử dụng Neo-tree cho quick navigation
- Sử dụng Telescope cho file search
- Sử dụng Spectre cho project-wide search/replace

## Compatibility

### Dotfiles Consistency
- Sử dụng cấu hình Yazi từ `~/.config/yazi`
- Keybindings nhất quán với Fish shell aliases
- Theme integration với Catppuccin

### LazyVim Ecosystem
- Tương thích với all LazyVim plugins
- Không conflict với existing keybindings
- Smooth integration với LSP và debugging

## Troubleshooting

### Yazi không khởi động
```bash
# Kiểm tra Yazi installation
which yazi

# Kiểm tra config directory
ls -la ~/.config/yazi/
```

### Keybindings không hoạt động
```vim
" Kiểm tra trong Neovim
:map <leader>e
:checkhealth lazy
```

### Integration issues
```vim
" Reload config
:lua require("config.yazi-config").setup()
:Lazy reload yazi.nvim
```

---

**Note**: Yazi integration là part của Deepin OS dotfiles ecosystem. Đảm bảo bạn đã chạy main install script để có full setup.
