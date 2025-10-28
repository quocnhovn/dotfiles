# Battery status function for Fish
function battery-status --description "Display detailed battery information"
    echo "🔋 Battery Status Report"
    echo "======================"

    # Check if battery exists
    if not test -d /sys/class/power_supply/BAT*
        echo "❌ No battery found"
        return 1
    end

    for battery in /sys/class/power_supply/BAT*
        set battery_name (basename $battery)

        if test -f $battery/capacity
            set capacity (cat $battery/capacity)
        else
            set capacity "Unknown"
        end

        if test -f $battery/status
            set status (cat $battery/status)
        else
            set status "Unknown"
        end

        # Battery icon based on capacity
        if test "$capacity" -gt 80
            set icon "🔋"
        else if test "$capacity" -gt 60
            set icon "🔋"
        else if test "$capacity" -gt 40
            set icon "🔋"
        else if test "$capacity" -gt 20
            set icon "🪫"
        else
            set icon "🪫"
        end

        echo "$icon $battery_name: $capacity% ($status)"

        # Power consumption if available
        if test -f $battery/power_now; and test -f $battery/voltage_now
            set power_now (cat $battery/power_now)
            set voltage_now (cat $battery/voltage_now)

            if test "$power_now" -gt 0
                set watts (math $power_now / 1000000)
                echo "   ⚡ Power: {$watts}W"
            end
        end

        # Time remaining estimation
        if test -f $battery/energy_now; and test -f $battery/power_now
            set energy_now (cat $battery/energy_now)
            set power_now (cat $battery/power_now)

            if test "$power_now" -gt 0
                set hours (math $energy_now / $power_now)
                set minutes (math "($hours - floor($hours)) * 60")
                echo "   ⏰ Estimated: "(math floor $hours)"h "(math floor $minutes)"m"
            end
        end
    end

    # AC Adapter status
    if test -d /sys/class/power_supply/ADP*; or test -d /sys/class/power_supply/AC*
        for adapter in /sys/class/power_supply/A{DP,C}*
            if test -f $adapter/online
                set online (cat $adapter/online)
                if test "$online" = "1"
                    echo "🔌 AC Adapter: Connected"
                else
                    echo "🔌 AC Adapter: Disconnected"
                end
            end
        end
    end

    # CPU frequency for power optimization
    if test -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
        set freq (cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
        set freq_mhz (math $freq / 1000)
        echo "🖥️  CPU Frequency: {$freq_mhz}MHz"
    end

    # Temperature if available
    if command -v sensors >/dev/null 2>&1
        set temp (sensors | grep -i "core 0" | grep -oP '\+\K[0-9.]+(?=°C)' | head -1)
        if test -n "$temp"
            echo "🌡️  CPU Temperature: {$temp}°C"
        end
    end

    echo "======================"
end
