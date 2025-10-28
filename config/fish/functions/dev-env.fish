# Development environment function for Fish
function dev-env --description "Setup development environment for current project"
    set project_dir (pwd)
    set project_name (basename $project_dir)

    echo "🚀 Setting up development environment for: $project_name"

    # Check for different project types
    if test -f composer.json
        echo "📦 PHP/Laravel project detected"

        if not test -d vendor
            echo "Installing Composer dependencies..."
            composer install
        end

        if test -f artisan
            echo "🔧 Laravel project - setting up..."
            if not test -f .env
                cp .env.example .env 2>/dev/null || echo "No .env.example found"
                php artisan key:generate 2>/dev/null || echo "Could not generate app key"
            end
        end

    else if test -f go.mod
        echo "🐹 Go project detected"
        go mod download

    else if test -f package.json
        echo "📦 Node.js project detected"

        if command -v npm >/dev/null 2>&1
            npm install
        else if command -v yarn >/dev/null 2>&1
            yarn install
        end

    else if test -f docker-compose.yml; or test -f docker-compose.yaml
        echo "🐳 Docker Compose project detected"
        docker-compose up -d

    else
        echo "ℹ️  Generic project - no specific setup needed"
    end

    # Check for VS Code workspace
    if test -f *.code-workspace
        echo "💻 VS Code workspace found"
        set workspace_file (ls *.code-workspace | head -1)
        echo "To open: code $workspace_file"
    end

    # Git status if it's a git repo
    if test -d .git
        echo "📋 Git status:"
        git status --short
    end

    echo "✅ Development environment ready!"
end
