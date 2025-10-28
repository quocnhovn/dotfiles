#!/bin/bash

# Deepin Browser Backup and Restore Script
# Sao lưu và khôi phục cấu hình, bookmark, extension của Deepin Browser

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
BROWSER_CONFIG_DIR="$HOME/.config/browser"
BACKUP_DIR="$DOTFILES_DIR/config/browser"

print_header() {
    echo -e "${BLUE}"
    echo "=============================================="
    echo "           DEEPIN BROWSER BACKUP"
    echo "=============================================="
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_browser_exists() {
    if [ ! -d "$BROWSER_CONFIG_DIR" ]; then
        print_error "Deepin Browser chưa được cài đặt hoặc chưa chạy lần đầu!"
        print_error "Vui lòng mở Deepin Browser và thiết lập cấu hình trước."
        return 1
    fi
}

backup_browser_data() {
    print_step "Đang sao lưu dữ liệu Deepin Browser..."

    # Create backup directory structure
    mkdir -p "$BACKUP_DIR/Default/virtual"
    mkdir -p "$BACKUP_DIR/Extensions"

    # Backup bookmarks
    if [ -f "$BROWSER_CONFIG_DIR/Default/virtual/Bookmarks" ]; then
        cp "$BROWSER_CONFIG_DIR/Default/virtual/Bookmarks" "$BACKUP_DIR/Default/virtual/"
        print_step "✓ Đã sao lưu Bookmarks"
    else
        print_warning "Không tìm thấy file Bookmarks"
    fi

    # Backup bookmarks backup file
    if [ -f "$BROWSER_CONFIG_DIR/Default/virtual/Bookmarks.bak" ]; then
        cp "$BROWSER_CONFIG_DIR/Default/virtual/Bookmarks.bak" "$BACKUP_DIR/Default/virtual/"
        print_step "✓ Đã sao lưu Bookmarks.bak"
    fi

    # Backup preferences
    if [ -f "$BROWSER_CONFIG_DIR/Default/virtual/Preferences" ]; then
        cp "$BROWSER_CONFIG_DIR/Default/virtual/Preferences" "$BACKUP_DIR/Default/virtual/"
        print_step "✓ Đã sao lưu Preferences"
    else
        print_warning "Không tìm thấy file Preferences"
    fi

    # Backup secure preferences
    if [ -f "$BROWSER_CONFIG_DIR/Default/Secure Preferences" ]; then
        cp "$BROWSER_CONFIG_DIR/Default/Secure Preferences" "$BACKUP_DIR/Default/"
        print_step "✓ Đã sao lưu Secure Preferences"
    fi

    # Backup extensions
    if [ -d "$BROWSER_CONFIG_DIR/Default/Extensions" ]; then
        # Create extensions list
        echo "# Danh sách Extensions đã cài đặt" > "$BACKUP_DIR/extensions_list.txt"
        echo "# Generated on $(date)" >> "$BACKUP_DIR/extensions_list.txt"
        echo "" >> "$BACKUP_DIR/extensions_list.txt"

        for ext_dir in "$BROWSER_CONFIG_DIR/Default/Extensions"/*; do
            if [ -d "$ext_dir" ]; then
                ext_id=$(basename "$ext_dir")
                # Find manifest file to get extension name
                manifest_file=""
                for version_dir in "$ext_dir"/*; do
                    if [ -d "$version_dir" ] && [ -f "$version_dir/manifest.json" ]; then
                        manifest_file="$version_dir/manifest.json"
                        break
                    fi
                done

                if [ -n "$manifest_file" ]; then
                    ext_name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$manifest_file" | sed 's/"name"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/')
                    version=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$manifest_file" | sed 's/"version"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/')
                    echo "Extension ID: $ext_id" >> "$BACKUP_DIR/extensions_list.txt"
                    echo "Name: $ext_name" >> "$BACKUP_DIR/extensions_list.txt"
                    echo "Version: $version" >> "$BACKUP_DIR/extensions_list.txt"
                    echo "---" >> "$BACKUP_DIR/extensions_list.txt"
                else
                    echo "Extension ID: $ext_id (No manifest found)" >> "$BACKUP_DIR/extensions_list.txt"
                    echo "---" >> "$BACKUP_DIR/extensions_list.txt"
                fi
            fi
        done

        # Copy entire Extensions directory
        cp -r "$BROWSER_CONFIG_DIR/Default/Extensions"/* "$BACKUP_DIR/Extensions/" 2>/dev/null || true
        print_step "✓ Đã sao lưu Extensions và tạo danh sách"
    else
        print_warning "Không tìm thấy thư mục Extensions"
    fi

    # Backup Local State (contains important browser settings)
    if [ -f "$BROWSER_CONFIG_DIR/Local State" ]; then
        cp "$BROWSER_CONFIG_DIR/Local State" "$BACKUP_DIR/"
        print_step "✓ Đã sao lưu Local State"
    fi

    # Create restore instructions
    create_restore_instructions

    print_step "✅ Hoàn thành sao lưu dữ liệu Deepin Browser!"
    echo -e "${GREEN}Vị trí sao lưu: $BACKUP_DIR${NC}"
}

create_restore_instructions() {
    cat > "$BACKUP_DIR/RESTORE_INSTRUCTIONS.md" << 'EOF'
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
EOF
}

restore_browser_data() {
    print_step "Đang khôi phục dữ liệu Deepin Browser..."

    # Check if backup exists
    if [ ! -d "$BACKUP_DIR" ]; then
        print_error "Không tìm thấy dữ liệu sao lưu!"
        print_error "Vui lòng chạy backup trước: ./scripts/setup/setup-browser-backup.sh backup"
        return 1
    fi

    # Check if browser is running
    if pgrep -f "browser" > /dev/null; then
        print_warning "Deepin Browser đang chạy!"
        print_warning "Vui lòng đóng browser trước khi khôi phục."
        read -p "Nhấn Enter sau khi đã đóng browser..."
    fi

    # Create browser config directory if not exists
    mkdir -p "$BROWSER_CONFIG_DIR/Default/virtual"

    # Restore bookmarks
    if [ -f "$BACKUP_DIR/Default/virtual/Bookmarks" ]; then
        cp "$BACKUP_DIR/Default/virtual/Bookmarks" "$BROWSER_CONFIG_DIR/Default/virtual/"
        print_step "✓ Đã khôi phục Bookmarks"
    fi

    if [ -f "$BACKUP_DIR/Default/virtual/Bookmarks.bak" ]; then
        cp "$BACKUP_DIR/Default/virtual/Bookmarks.bak" "$BROWSER_CONFIG_DIR/Default/virtual/"
        print_step "✓ Đã khôi phục Bookmarks.bak"
    fi

    # Restore preferences
    if [ -f "$BACKUP_DIR/Default/virtual/Preferences" ]; then
        cp "$BACKUP_DIR/Default/virtual/Preferences" "$BROWSER_CONFIG_DIR/Default/virtual/"
        print_step "✓ Đã khôi phục Preferences"
    fi

    if [ -f "$BACKUP_DIR/Default/Secure Preferences" ]; then
        cp "$BACKUP_DIR/Default/Secure Preferences" "$BROWSER_CONFIG_DIR/Default/"
        print_step "✓ Đã khôi phục Secure Preferences"
    fi

    # Restore extensions
    if [ -d "$BACKUP_DIR/Extensions" ]; then
        mkdir -p "$BROWSER_CONFIG_DIR/Default/Extensions"
        cp -r "$BACKUP_DIR/Extensions"/* "$BROWSER_CONFIG_DIR/Default/Extensions/" 2>/dev/null || true
        print_step "✓ Đã khôi phục Extensions"
    fi

    # Restore Local State
    if [ -f "$BACKUP_DIR/Local State" ]; then
        cp "$BACKUP_DIR/Local State" "$BROWSER_CONFIG_DIR/"
        print_step "✓ Đã khôi phục Local State"
    fi

    print_step "✅ Hoàn thành khôi phục dữ liệu Deepin Browser!"
    print_step "Hãy mở Deepin Browser để kiểm tra kết quả."

    if [ -f "$BACKUP_DIR/extensions_list.txt" ]; then
        echo -e "${YELLOW}📋 Danh sách extensions đã sao lưu:${NC}"
        cat "$BACKUP_DIR/extensions_list.txt" | grep -E "(Name:|Extension ID:)" | head -20
        echo ""
        echo -e "${YELLOW}💡 Lưu ý: Một số extension có thể cần được kích hoạt lại trong browser settings.${NC}"
    fi
}

show_help() {
    echo "Sử dụng:"
    echo "  $0 backup    - Sao lưu dữ liệu browser"
    echo "  $0 restore   - Khôi phục dữ liệu browser"
    echo "  $0 list      - Hiển thị danh sách extensions đã sao lưu"
    echo "  $0 help      - Hiển thị hướng dẫn này"
}

list_extensions() {
    if [ -f "$BACKUP_DIR/extensions_list.txt" ]; then
        echo -e "${BLUE}📋 Danh sách Extensions đã sao lưu:${NC}"
        echo ""
        cat "$BACKUP_DIR/extensions_list.txt"
    else
        print_error "Không tìm thấy danh sách extensions!"
        print_error "Vui lòng chạy backup trước: $0 backup"
    fi
}

main() {
    print_header

    case "${1:-}" in
        "backup")
            check_browser_exists && backup_browser_data
            ;;
        "restore")
            restore_browser_data
            ;;
        "list")
            list_extensions
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
}

main "$@"
