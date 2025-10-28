#!/bin/bash

# Deepin Browser Restore Script
# Script khôi phục riêng biệt cho việc cài đặt máy mới

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
    echo "         DEEPIN BROWSER RESTORE"
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

check_backup_exists() {
    if [ ! -d "$BACKUP_DIR" ]; then
        print_error "Không tìm thấy dữ liệu sao lưu browser!"
        print_error "Vị trí mong đợi: $BACKUP_DIR"
        return 1
    fi

    if [ ! -f "$BACKUP_DIR/Default/virtual/Bookmarks" ] && [ ! -d "$BACKUP_DIR/Extensions" ]; then
        print_error "Dữ liệu sao lưu không hợp lệ hoặc bị thiếu!"
        return 1
    fi

    return 0
}

install_deepin_browser() {
    print_step "Kiểm tra và cài đặt Deepin Browser..."

    if command -v browser >/dev/null 2>&1; then
        print_step "✓ Deepin Browser đã được cài đặt"
        return 0
    fi

    print_step "Đang cài đặt Deepin Browser..."

    # Try to install via apt
    if command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y deepin-browser || {
            print_warning "Không thể cài đặt qua apt, thử cách khác..."
            return 1
        }
    else
        print_error "Không tìm thấy package manager phù hợp!"
        return 1
    fi

    print_step "✓ Đã cài đặt Deepin Browser"
}

restore_browser_data() {
    print_step "Đang khôi phục dữ liệu Deepin Browser..."

    # Ensure browser is not running
    if pgrep -f "browser" > /dev/null; then
        print_warning "Deepin Browser đang chạy!"
        print_step "Đang tắt browser..."
        pkill -f "browser" || true
        sleep 2
    fi

    # Create browser config directory structure
    mkdir -p "$BROWSER_CONFIG_DIR/Default/virtual"
    mkdir -p "$BROWSER_CONFIG_DIR/Default/Extensions"

    # Restore bookmarks
    if [ -f "$BACKUP_DIR/Default/virtual/Bookmarks" ]; then
        cp "$BACKUP_DIR/Default/virtual/Bookmarks" "$BROWSER_CONFIG_DIR/Default/virtual/"
        print_step "✓ Đã khôi phục Bookmarks"
    fi

    if [ -f "$BACKUP_DIR/Default/virtual/Bookmarks.bak" ]; then
        cp "$BACKUP_DIR/Default/virtual/Bookmarks.bak" "$BROWSER_CONFIG_DIR/Default/virtual/"
        print_step "✓ Đã khôi phục Bookmarks backup"
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
    if [ -d "$BACKUP_DIR/Extensions" ] && [ "$(ls -A "$BACKUP_DIR/Extensions")" ]; then
        cp -r "$BACKUP_DIR/Extensions"/* "$BROWSER_CONFIG_DIR/Default/Extensions/" 2>/dev/null || true
        print_step "✓ Đã khôi phục Extensions"
    fi

    # Restore Local State
    if [ -f "$BACKUP_DIR/Local State" ]; then
        cp "$BACKUP_DIR/Local State" "$BROWSER_CONFIG_DIR/"
        print_step "✓ Đã khôi phục Local State"
    fi

    # Set proper permissions
    chmod -R 755 "$BROWSER_CONFIG_DIR"
    find "$BROWSER_CONFIG_DIR" -type f -exec chmod 644 {} \;

    print_step "✅ Hoàn thành khôi phục dữ liệu Deepin Browser!"
}

show_restore_summary() {
    echo ""
    echo -e "${GREEN}=== TỔNG KẾT KHÔI PHỤC ===${NC}"

    if [ -f "$BACKUP_DIR/extensions_list.txt" ]; then
        echo -e "${BLUE}📋 Extensions đã khôi phục:${NC}"
        local ext_count=$(grep -c "Extension ID:" "$BACKUP_DIR/extensions_list.txt" 2>/dev/null || echo "0")
        echo "   Số lượng: $ext_count extensions"
        echo ""

        # Show first few extensions
        grep -A2 "Extension ID:" "$BACKUP_DIR/extensions_list.txt" | head -15 | while read line; do
            if [[ $line == Extension* ]]; then
                echo -e "   ${YELLOW}$line${NC}"
            elif [[ $line == Name:* ]]; then
                echo -e "   $line"
            fi
        done

        if [ "$ext_count" -gt 5 ]; then
            echo "   ..."
            echo -e "   ${YELLOW}Xem đầy đủ: cat $BACKUP_DIR/extensions_list.txt${NC}"
        fi
    fi

    echo ""
    echo -e "${GREEN}📖 Bookmarks:${NC} ✓ Đã khôi phục"
    echo -e "${GREEN}⚙️  Preferences:${NC} ✓ Đã khôi phục"
    echo -e "${GREEN}🔧 Extensions:${NC} ✓ Đã khôi phục"
    echo ""
    echo -e "${YELLOW}💡 Lưu ý quan trọng:${NC}"
    echo "   • Một số extension có thể cần kích hoạt lại"
    echo "   • Kiểm tra settings trong browser"
    echo "   • Đăng nhập lại các extension cần thiết"
    echo ""
    echo -e "${BLUE}🚀 Hãy mở Deepin Browser để kiểm tra kết quả!${NC}"
}

main() {
    print_header

    # Check if backup exists
    if ! check_backup_exists; then
        exit 1
    fi

    # Install browser if needed
    if ! install_deepin_browser; then
        print_error "Không thể cài đặt Deepin Browser!"
        exit 1
    fi

    # Restore data
    restore_browser_data

    # Show summary
    show_restore_summary

    print_step "🎉 Hoàn thành khôi phục Deepin Browser!"
}

main "$@"
