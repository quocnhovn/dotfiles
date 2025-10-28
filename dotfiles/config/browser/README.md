# Deepin Browser Backup & Restore Guide

## 🚀 Tính năng

Script này giúp bạn:
- 📚 Sao lưu bookmarks của Deepin Browser
- 🔧 Sao lưu tất cả extensions đã cài đặt
- ⚙️ Sao lưu preferences và settings
- 🔄 Khôi phục hoàn toàn khi cài máy mới

## 📖 Cách sử dụng

### 1. Sao lưu dữ liệu hiện tại

```bash
# Chạy script backup
./scripts/setup/setup-browser-backup.sh backup
```

### 2. Xem danh sách extensions đã sao lưu

```bash
# Xem danh sách extensions
./scripts/setup/setup-browser-backup.sh list
```

### 3. Khôi phục trên máy mới

```bash
# Chạy script khôi phục (tự động cài Deepin Browser nếu chưa có)
./scripts/setup/setup-browser-restore.sh
```

## 📁 Dữ liệu được sao lưu

### Bookmarks
- `~/.config/browser/Default/virtual/Bookmarks`
- `~/.config/browser/Default/virtual/Bookmarks.bak`

### Extensions
- Toàn bộ thư mục `~/.config/browser/Default/Extensions/`
- Danh sách chi tiết extensions trong `extensions_list.txt`

### Settings & Preferences
- `~/.config/browser/Default/virtual/Preferences`
- `~/.config/browser/Default/Secure Preferences`
- `~/.config/browser/Local State`

## 🔄 Quy trình khôi phục trên máy mới

1. **Clone dotfiles:**
   ```bash
   git clone <your-repo> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Chạy khôi phục:**
   ```bash
   ./scripts/setup/setup-browser-restore.sh
   ```

3. **Kiểm tra kết quả:**
   - Mở Deepin Browser
   - Kiểm tra bookmarks
   - Kích hoạt lại extensions nếu cần

## ⚠️ Lưu ý quan trọng

- **Đóng browser** trước khi khôi phục
- Một số extension có thể cần **đăng nhập lại**
- Kiểm tra **settings** sau khi khôi phục
- Dữ liệu được lưu trong `config/browser/` của dotfiles

## 🛠️ Troubleshooting

### Browser không mở được sau khôi phục
```bash
# Xóa cache và khởi động lại
rm -rf ~/.cache/browser/
./scripts/setup/setup-browser-restore.sh
```

### Extensions không hoạt động
1. Mở Deepin Browser
2. Vào Settings → Extensions
3. Kích hoạt lại các extensions cần thiết

### Bookmarks bị mất
```bash
# Kiểm tra file backup
ls -la config/browser/Default/virtual/
# Chạy lại khôi phục
./scripts/setup/setup-browser-restore.sh
```

## 📋 Danh sách lệnh đầy đủ

```bash
# Sao lưu
./scripts/setup/setup-browser-backup.sh backup

# Khôi phục
./scripts/setup/setup-browser-backup.sh restore

# Xem danh sách extensions
./scripts/setup/setup-browser-backup.sh list

# Xem hướng dẫn
./scripts/setup/setup-browser-backup.sh help

# Khôi phục cho máy mới (tích hợp cài đặt)
./scripts/setup/setup-browser-restore.sh
```

## 🎯 Tích hợp với install.sh

Script backup được tích hợp vào `install.sh`:
- Tự động hỏi có muốn backup khi cài đặt
- Hoạt động với các tools khác trong dotfiles
- Hướng dẫn sau khi cài đặt hoàn tất

---

💡 **Pro tip:** Chạy backup định kỳ để đảm bảo dữ liệu browser luôn được bảo vệ!
