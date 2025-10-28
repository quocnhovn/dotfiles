#!/bin/bash

# Battery Optimization Setup Script for LG Laptop
# This script configures TLP and auto-cpufreq for optimal battery life

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[BATTERY]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_status "Setting up battery optimization for LG laptop..."

# Configure TLP
print_status "Configuring TLP..."
if [ -f "/etc/tlp.conf" ]; then
    sudo cp /etc/tlp.conf /etc/tlp.conf.backup
    print_status "Backed up original TLP configuration"
fi

sudo cp "$DOTFILES_DIR/system/tlp.conf" /etc/tlp.conf
sudo systemctl enable tlp
sudo systemctl start tlp

# Configure auto-cpufreq
print_status "Configuring auto-cpufreq..."
cat > /tmp/auto-cpufreq.conf << 'EOF'
# auto-cpufreq configuration for LG Laptop

[charger]
# Settings to apply when laptop is connected to a power source
governor = performance
scaling_min_freq = 1200000
scaling_max_freq = 4200000
turbo = auto

[battery]
# Settings to apply when laptop is using battery power
governor = powersave
scaling_min_freq = 800000
scaling_max_freq = 2400000
turbo = auto
EOF

sudo cp /tmp/auto-cpufreq.conf /etc/auto-cpufreq.conf
sudo auto-cpufreq --install

# Create power profile switching script
print_status "Creating power profile scripts..."
cat > "$DOTFILES_DIR/scripts/utils/power-mode.sh" << 'EOF'
#!/bin/bash

# Power mode switcher for development work

case "$1" in
    performance)
        echo "Switching to Performance Mode..."
        sudo tlp ac
        sudo cpufreq-set -g performance
        echo "Performance mode activated"
        ;;
    powersave)
        echo "Switching to Power Save Mode..."
        sudo tlp bat
        sudo cpufreq-set -g powersave
        echo "Power save mode activated"
        ;;
    status)
        echo "Current TLP status:"
        sudo tlp-stat -s
        echo ""
        echo "Current CPU governor:"
        cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | head -1
        ;;
    *)
        echo "Usage: $0 {performance|powersave|status}"
        echo ""
        echo "performance - Switch to high performance mode"
        echo "powersave   - Switch to battery saving mode"
        echo "status      - Show current power management status"
        exit 1
        ;;
esac
EOF

chmod +x "$DOTFILES_DIR/scripts/utils/power-mode.sh"

# Create battery monitoring script
cat > "$DOTFILES_DIR/scripts/utils/battery-status.sh" << 'EOF'
#!/bin/bash

# Battery status and health monitoring script

BATTERY_PATH="/sys/class/power_supply/BAT0"

if [ ! -d "$BATTERY_PATH" ]; then
    echo "Battery not found at $BATTERY_PATH"
    exit 1
fi

echo "=== Battery Status ==="
echo "Status: $(cat $BATTERY_PATH/status)"
echo "Capacity: $(cat $BATTERY_PATH/capacity)%"

if [ -f "$BATTERY_PATH/energy_now" ] && [ -f "$BATTERY_PATH/energy_full" ]; then
    ENERGY_NOW=$(cat $BATTERY_PATH/energy_now)
    ENERGY_FULL=$(cat $BATTERY_PATH/energy_full)
    ENERGY_DESIGN=$(cat $BATTERY_PATH/energy_full_design 2>/dev/null || echo "N/A")

    echo "Energy Now: $(echo "scale=2; $ENERGY_NOW/1000000" | bc) Wh"
    echo "Energy Full: $(echo "scale=2; $ENERGY_FULL/1000000" | bc) Wh"

    if [ "$ENERGY_DESIGN" != "N/A" ]; then
        HEALTH=$(echo "scale=2; $ENERGY_FULL*100/$ENERGY_DESIGN" | bc)
        echo "Battery Health: ${HEALTH}%"
    fi
fi

echo ""
echo "=== Power Consumption ==="
if [ -f "$BATTERY_PATH/power_now" ]; then
    POWER_NOW=$(cat $BATTERY_PATH/power_now)
    echo "Current Power Draw: $(echo "scale=2; $POWER_NOW/1000000" | bc) W"
fi

echo ""
echo "=== TLP Status ==="
tlp-stat -s | grep -E "(TLP|Mode|Governor)"

echo ""
echo "=== CPU Frequency ==="
echo "Current Governor: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)"
echo "Current Frequency: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | head -1) kHz"
echo "Min Frequency: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq) kHz"
echo "Max Frequency: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq) kHz"
EOF

chmod +x "$DOTFILES_DIR/scripts/utils/battery-status.sh"

# Create thermal monitoring script
cat > "$DOTFILES_DIR/scripts/utils/thermal-status.sh" << 'EOF'
#!/bin/bash

# Thermal monitoring script

echo "=== CPU Temperature ==="
if command -v sensors &> /dev/null; then
    sensors | grep -E "(Core|CPU|temp)"
else
    echo "lm-sensors not installed. Install with: sudo apt install lm-sensors"
    echo "Then run: sudo sensors-detect"
fi

echo ""
echo "=== CPU Usage ==="
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU Usage: " 100 - $1 "%"}'

echo ""
echo "=== Memory Usage ==="
free -h

echo ""
echo "=== Thermal Zones ==="
for zone in /sys/class/thermal/thermal_zone*/; do
    if [ -f "$zone/type" ] && [ -f "$zone/temp" ]; then
        TYPE=$(cat "$zone/type")
        TEMP=$(cat "$zone/temp")
        if [ "$TEMP" -gt 0 ]; then
            TEMP_C=$(echo "scale=1; $TEMP/1000" | bc 2>/dev/null || echo "$TEMP")
            echo "$TYPE: ${TEMP_C}°C"
        fi
    fi
done
EOF

chmod +x "$DOTFILES_DIR/scripts/utils/thermal-status.sh"

# Install additional battery tools
print_status "Installing additional battery monitoring tools..."
sudo apt install -y powertop lm-sensors acpi

# Configure sensors
print_status "Configuring hardware sensors..."
sudo sensors-detect --auto

print_success "Battery optimization setup completed!"
print_status "Available commands:"
echo "  battery-status.sh  - Check battery status and health"
echo "  thermal-status.sh  - Monitor CPU temperature and thermal zones"
echo "  power-mode.sh      - Switch between performance and power saving modes"
echo ""
print_status "TLP and auto-cpufreq are now active and will automatically optimize power usage"
print_warning "Reboot recommended to ensure all power management features are active"
