# Hướng dẫn khôi phục Deepin Browser

## Cách khôi phục tự động
```bash
# Chạy script khôi phục
./scripts/setup/setup-browser-restore.sh
```

## Cách khôi phục thủ công

### 1. Đóng Deepin Browser
Đảm bảo browser đã được đóng hoàn toàn trước khi khôi phục.

### 2. Khôi phục Bookmarks
```bash
cp config/browser/Default/virtual/Bookmarks ~/.config/browser/Default/virtual/
cp config/browser/Default/virtual/Bookmarks.bak ~/.config/browser/Default/virtual/
```

### 3. Khôi phục Preferences
```bash
cp config/browser/Default/virtual/Preferences ~/.config/browser/Default/virtual/
cp "config/browser/Default/Secure Preferences" ~/.config/browser/Default/
```

### 4. Khôi phục Extensions
```bash
# Tạo thư mục Extensions nếu chưa có
mkdir -p ~/.config/browser/Default/Extensions

# Copy tất cả extensions
cp -r config/browser/Extensions/* ~/.config/browser/Default/Extensions/
```

### 5. Khôi phục Local State
```bash
cp config/browser/Local\ State ~/.config/browser/
```

### 6. Khởi động lại browser
Mở Deepin Browser để kiểm tra kết quả.

## Lưu ý
- Extensions có thể cần được kích hoạt lại trong settings
- Một số extension có thể cần đăng nhập lại
- Kiểm tra danh sách extensions trong file `extensions_list.txt`
