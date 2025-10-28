#!/bin/bash

# VS Code Setup Script
# This script configures VS Code with optimized settings for fullstack development

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VSCODE_CONFIG_DIR="$HOME/.config/Code/User"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[VSCODE]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_status "Setting up VS Code configuration..."

# Create VS Code config directory if it doesn't exist
mkdir -p "$VSCODE_CONFIG_DIR"

# Backup existing configurations
if [ -f "$VSCODE_CONFIG_DIR/settings.json" ]; then
    print_status "Backing up existing VS Code settings..."
    cp "$VSCODE_CONFIG_DIR/settings.json" "$VSCODE_CONFIG_DIR/settings.json.backup"
fi

if [ -f "$VSCODE_CONFIG_DIR/keybindings.json" ]; then
    print_status "Backing up existing VS Code keybindings..."
    cp "$VSCODE_CONFIG_DIR/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json.backup"
fi

# Copy new configurations
print_status "Installing VS Code settings..."
cp "$DOTFILES_DIR/config/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
cp "$DOTFILES_DIR/config/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"

# Install extensions
print_status "Installing VS Code extensions..."
chmod +x "$DOTFILES_DIR/scripts/setup/vscode-extensions.sh"
"$DOTFILES_DIR/scripts/setup/vscode-extensions.sh"

# Create workspace snippets directory
mkdir -p "$VSCODE_CONFIG_DIR/snippets"

# Create custom snippets for PHP/Laravel
cat > "$VSCODE_CONFIG_DIR/snippets/php.json" << 'EOF'
{
  "Laravel Route": {
    "prefix": "route",
    "body": [
      "Route::${1:get}('${2:uri}', [${3:Controller}::class, '${4:method}'])->name('${5:name}');"
    ],
    "description": "Laravel Route definition"
  },
  "Laravel Controller Method": {
    "prefix": "controller",
    "body": [
      "public function ${1:method}(${2:Request} \\$request)",
      "{",
      "    ${3:// Method body}",
      "    return ${4:response()};",
      "}"
    ],
    "description": "Laravel Controller Method"
  },
  "Laravel Migration": {
    "prefix": "migration",
    "body": [
      "public function up()",
      "{",
      "    Schema::create('${1:table_name}', function (Blueprint \\$table) {",
      "        \\$table->id();",
      "        ${2:// Add columns here}",
      "        \\$table->timestamps();",
      "    });",
      "}"
    ],
    "description": "Laravel Migration up method"
  },
  "PHP Class": {
    "prefix": "class",
    "body": [
      "<?php",
      "",
      "namespace ${1:App\\\\};",
      "",
      "class ${2:ClassName}",
      "{",
      "    ${3:// Class body}",
      "}"
    ],
    "description": "PHP Class template"
  }
}
EOF

# Create custom snippets for Vue.js
cat > "$VSCODE_CONFIG_DIR/snippets/vue.json" << 'EOF'
{
  "Vue 3 Composition API Component": {
    "prefix": "vue3",
    "body": [
      "<template>",
      "  <div>",
      "    ${1:<!-- Template content -->}",
      "  </div>",
      "</template>",
      "",
      "<script setup>",
      "import { ref, reactive, computed, onMounted } from 'vue'",
      "",
      "${2:// Component logic}",
      "</script>",
      "",
      "<style scoped>",
      "${3:/* Component styles */}",
      "</style>"
    ],
    "description": "Vue 3 Composition API Component"
  },
  "Vue Ref": {
    "prefix": "vref",
    "body": [
      "const ${1:name} = ref(${2:null})"
    ],
    "description": "Vue 3 ref"
  },
  "Vue Reactive": {
    "prefix": "vreactive",
    "body": [
      "const ${1:state} = reactive({",
      "  ${2:// properties}",
      "})"
    ],
    "description": "Vue 3 reactive"
  },
  "Vue Computed": {
    "prefix": "vcomputed",
    "body": [
      "const ${1:name} = computed(() => {",
      "  return ${2:// computation}",
      "})"
    ],
    "description": "Vue 3 computed"
  }
}
EOF

# Create custom snippets for JavaScript
cat > "$VSCODE_CONFIG_DIR/snippets/javascript.json" << 'EOF'
{
  "Arrow Function": {
    "prefix": "af",
    "body": [
      "const ${1:name} = (${2:params}) => {",
      "  ${3:// Function body}",
      "}"
    ],
    "description": "Arrow Function"
  },
  "Async Arrow Function": {
    "prefix": "aaf",
    "body": [
      "const ${1:name} = async (${2:params}) => {",
      "  ${3:// Async function body}",
      "}"
    ],
    "description": "Async Arrow Function"
  },
  "Try Catch": {
    "prefix": "trycatch",
    "body": [
      "try {",
      "  ${1:// Try block}",
      "} catch (error) {",
      "  ${2:console.error(error)}",
      "}"
    ],
    "description": "Try Catch block"
  },
  "Console Log": {
    "prefix": "cl",
    "body": [
      "console.log(${1:message})"
    ],
    "description": "Console Log"
  }
}
EOF

# Create tasks.json template for common development tasks
mkdir -p "$HOME/.vscode"
cat > "$HOME/.vscode/tasks.json" << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "PHP: Start Development Server",
            "type": "shell",
            "command": "php",
            "args": ["-S", "localhost:8000"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            },
            "isBackground": true
        },
        {
            "label": "Laravel: Serve",
            "type": "shell",
            "command": "php",
            "args": ["artisan", "serve"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            },
            "isBackground": true
        },
        {
            "label": "Laravel: Migrate",
            "type": "shell",
            "command": "php",
            "args": ["artisan", "migrate"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "Node: Start Development Server",
            "type": "shell",
            "command": "npm",
            "args": ["run", "dev"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            },
            "isBackground": true
        },
        {
            "label": "Docker: Compose Up",
            "type": "shell",
            "command": "docker-compose",
            "args": ["up", "-d"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "Docker: Compose Down",
            "type": "shell",
            "command": "docker-compose",
            "args": ["down"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "Go: Run",
            "type": "shell",
            "command": "go",
            "args": ["run", "main.go"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        }
    ]
}
EOF

print_success "VS Code configuration completed!"
print_status "Custom snippets created for PHP, Vue.js, and JavaScript"
print_status "Development tasks configured for Laravel, Node.js, Go, and Docker"
print_warning "Please restart VS Code to apply all changes"
