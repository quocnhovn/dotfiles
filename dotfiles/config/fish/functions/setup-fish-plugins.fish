# Setup Fish shell plugins using Fisher
# Based on best practices from dotfiles-docs.vercel.app

function setup-fish-plugins --description "Install Fish shell plugins using Fisher"
    echo "🐟 Installing Fish shell plugins..."

    # Check if Fisher is installed
    if not type -q fisher
        echo "❌ Fisher not found. Installing Fisher first..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end

    # List of plugins to install
    set plugins \
        catppuccin/fish \
        franciscolourenco/done \
        PatrickF1/fzf.fish \
        gazorby/fish-abbreviation-tips \
        oh-my-fish/plugin-sudope \
        nickeb96/puffer-fish \
        jorgebucaran/autopair.fish

    echo "📦 Installing plugins:"
    for plugin in $plugins
        echo "  - $plugin"
        fisher install $plugin
    end

    echo "🎨 Configuring Catppuccin theme..."
    fish_config theme save "Catppuccin Macchiato"

    echo "✅ Fish plugins installation completed!"
    echo "🔄 Please restart Fish shell to see all changes"
    echo ""
    echo "📚 Installed plugins:"
    echo "  • Catppuccin - Beautiful theme"
    echo "  • Done - Notifications for long commands"
    echo "  • fzf.fish - Fuzzy finder integration"
    echo "  • Abbreviation-tips - Show available abbreviations"
    echo "  • Sudope - Press ESC twice to add sudo"
    echo "  • Puffer-fish - Text expansions"
    echo "  • Autopair - Auto-close brackets and quotes"
end
