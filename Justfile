# Interactive Justfile for Spage
# Default task - shows interactive menu
default:
    @just menu

# Show interactive menu
menu:
    @echo "🚀 Spage Build & Run Menu"
    @echo "========================"
    @echo ""
    @echo "Available commands:"
    @echo "  1) build         - Build spage locally"
    @echo "  2) install       - Install spage locally"
    @echo "  3) run-local     - Run with local build (interactive)"
    @echo "  4) run-remote    - Run with go run (remote package)"
    @echo "  5) generate      - Generate code from playbook (interactive)"
    @echo "  6) test          - Run tests"
    @echo "  7) clean         - Clean build artifacts"
    @echo "  8) update        - Update to latest remote version"
    @echo "  9) version       - Show version info"
    @echo ""
    @echo "Usage: just <command>"
    @echo "Example: just run-local"

# Build the spage binary
build:
    @echo "🔨 Building spage locally..."
    go build -o spage .
    @echo "✅ Build complete! Binary: ./spage"

# Install the spage binary
install:
    @echo "📦 Installing spage..."
    go install github.com/AlexanderGrooff/spage@latest
    @echo "✅ Spage installed! Available as 'spage' command"

# Interactive local run - prompts for command and arguments
run-local:
    #!/usr/bin/env bash
    set -euo pipefail

    # Ensure local binary exists
    if [ ! -f "./spage" ]; then
        echo "❌ Local spage binary not found. Building..."
        just build
    fi

    echo "🏃 Running Spage locally"
    echo "======================"
    echo ""
    echo "Available commands:"
    echo "  1) generate  - Generate Go code from playbook"
    echo "  2) run       - Run playbook directly"
    echo "  3) version   - Show version"
    echo "  4) help      - Show help"
    echo "  5) custom    - Enter custom command"
    echo ""
    read -p "Select command (1-5): " choice

    case $choice in
        1)
            read -p "Enter playbook path: " playbook
            read -p "Enter output file (default: generated_tasks.go): " output
            output=${output:-generated_tasks.go}
            echo "🎯 Generating: ./spage generate --playbook '$playbook' --output '$output'"
            ./spage generate --playbook "$playbook" --output "$output"
            ;;
        2)
            read -p "Enter inventory path: " inventory
            read -p "Enter playbook path: " playbook
            read -p "Extra arguments (optional): " extra_args
            echo "🎯 Running: ./spage run --inventory '$inventory' --playbook '$playbook' $extra_args"
            ./spage run --inventory "$inventory" --playbook "$playbook" $extra_args
            ;;
        3)
            echo "🎯 Running: ./spage version"
            ./spage version
            ;;
        4)
            echo "🎯 Running: ./spage --help"
            ./spage --help
            ;;
        5)
            read -p "Enter custom command: " custom_cmd
            echo "🎯 Running: ./spage $custom_cmd"
            ./spage $custom_cmd
            ;;
        *)
            echo "❌ Invalid choice"
            exit 1
            ;;
    esac

# Interactive remote run - uses go run with remote package
run-remote:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "☁️  Running Spage from remote package"
    echo "===================================="
    echo ""
    echo "Available commands:"
    echo "  1) generate  - Generate Go code from playbook"
    echo "  2) run       - Run playbook directly"
    echo "  3) version   - Show version"
    echo "  4) help      - Show help"
    echo "  5) custom    - Enter custom command"
    echo ""
    read -p "Select command (1-5): " choice

    case $choice in
        1)
            read -p "Enter playbook path: " playbook
            read -p "Enter output file (default: generated_tasks.go): " output
            output=${output:-generated_tasks.go}
            echo "🎯 Running: go run github.com/AlexanderGrooff/spage@latest generate --playbook '$playbook' --output '$output'"
            go run github.com/AlexanderGrooff/spage@latest generate --playbook "$playbook" --output "$output"
            ;;
        2)
            read -p "Enter inventory path: " inventory
            read -p "Enter playbook path: " playbook
            read -p "Extra arguments (optional): " extra_args
            echo "🎯 Running: go run github.com/AlexanderGrooff/spage@latest run --inventory '$inventory' --playbook '$playbook' $extra_args"
            go run github.com/AlexanderGrooff/spage@latest run --inventory "$inventory" --playbook "$playbook" $extra_args
            ;;
        3)
            echo "🎯 Running: go run github.com/AlexanderGrooff/spage@latest version"
            go run github.com/AlexanderGrooff/spage@latest version
            ;;
        4)
            echo "🎯 Running: go run github.com/AlexanderGrooff/spage@latest --help"
            go run github.com/AlexanderGrooff/spage@latest --help
            ;;
        5)
            read -p "Enter custom command: " custom_cmd
            echo "🎯 Running: go run github.com/AlexanderGrooff/spage@latest $custom_cmd"
            go run github.com/AlexanderGrooff/spage@latest $custom_cmd
            ;;
        *)
            echo "❌ Invalid choice"
            exit 1
            ;;
    esac

# Interactive generate command
generate:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "📝 Spage Code Generation"
    echo "======================="
    echo ""
    echo "Choose execution method:"
    echo "  1) Local build (requires ./spage binary)"
    echo "  2) Remote package (go run github.com/AlexanderGrooff/spage@latest)"
    echo ""
    read -p "Select method (1-2): " method

    read -p "Enter playbook path: " playbook
    read -p "Enter output file (default: generated_tasks.go): " output
    output=${output:-generated_tasks.go}

    # Validate playbook exists
    if [ ! -f "$playbook" ]; then
        echo "❌ Playbook file '$playbook' not found!"
        exit 1
    fi

    case $method in
        1)
            # Ensure local binary exists
            if [ ! -f "./spage" ]; then
                echo "🔨 Local binary not found. Building..."
                just build
            fi
            echo "🎯 Generating with local build..."
            ./spage generate --playbook "$playbook" --output "$output"
            ;;
        2)
            echo "🎯 Generating with remote package..."
            go run github.com/AlexanderGrooff/spage@latest generate --playbook "$playbook" --output "$output"
            ;;
        *)
            echo "❌ Invalid choice"
            exit 1
            ;;
    esac

    echo "✅ Generated: $output"
    echo "📊 File size: $(du -h "$output" | cut -f1)"
    echo ""
    echo "Next steps:"
    echo "  - Compile: go build -o spage_playbook $output"
    echo "  - Run:     ./spage_playbook --inventory your_inventory.yaml"

# Quick generate with non-interactive parameters
quick-generate playbook output="generated_tasks.go" method="local":
    #!/usr/bin/env bash
    set -euo pipefail

    echo "🚀 Quick Generate: {{playbook}} -> {{output}}"

    case {{method}} in
        local)
            if [ ! -f "./spage" ]; then
                echo "🔨 Building local binary..."
                just build
            fi
            ./spage generate --playbook {{playbook}} --output {{output}}
            ;;
        remote)
            go run github.com/AlexanderGrooff/spage@latest generate --playbook {{playbook}} --output {{output}}
            ;;
        *)
            echo "❌ Invalid method: {{method}} (use 'local' or 'remote')"
            exit 1
            ;;
    esac

# Run tests
test:
    @echo "🧪 Running tests..."
    go test ./...
    @echo "✅ Tests completed"

# Clean build artifacts
clean:
    @echo "🧹 Cleaning up..."
    rm -f spage
    rm -f generated_tasks.go
    rm -f spage_playbook
    @echo "✅ Cleanup complete"

# Update to latest remote version
update:
    @echo "🔄 Updating to latest version..."
    go clean -modcache
    go get -u github.com/AlexanderGrooff/spage@latest
    @echo "✅ Updated to latest version"

# Show version information
version:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "📊 Spage Version Information"
    echo "==========================="
    echo ""

    if [ -f "./spage" ]; then
        echo "Local binary:"
        ./spage version 2>/dev/null || echo "  Version command not available"
        echo "  Binary size: $(du -h ./spage | cut -f1)"
        echo "  Last modified: $(stat -c %y ./spage 2>/dev/null || stat -f %Sm ./spage 2>/dev/null || echo 'Unknown')"
    else
        echo "Local binary: Not found"
    fi

    echo ""
    echo "Remote package (latest):"
    go run github.com/AlexanderGrooff/spage@latest version 2>/dev/null || echo "  Could not fetch remote version"

    echo ""
    echo "Go environment:"
    echo "  Go version: $(go version)"
    echo "  GOPATH: ${GOPATH:-Not set}"
    echo "  GOOS/GOARCH: $(go env GOOS)/$(go env GOARCH)"

# Development helpers
dev:
    @echo "🛠️  Development Commands"
    @echo "======================="
    @echo ""
    @echo "  just watch     - Watch for changes and rebuild"
    @echo "  just lint      - Run linting"
    @echo "  just format    - Format code"
    @echo "  just bench     - Run benchmarks"

# Watch for changes and rebuild (requires entr or similar)
watch:
    #!/usr/bin/env bash
    if command -v entr > /dev/null; then
        echo "👀 Watching for changes... (Ctrl+C to stop)"
        find . -name "*.go" | entr -r just build
    elif command -v fswatch > /dev/null; then
        echo "👀 Watching for changes... (Ctrl+C to stop)"
        fswatch -o . | xargs -n1 -I{} just build
    else
        echo "❌ Please install 'entr' or 'fswatch' for watch functionality"
        echo "   - macOS: brew install entr"
        echo "   - Ubuntu: apt-get install entr"
    fi

# Run linting
lint:
    @echo "🔍 Running linter..."
    @if command -v golangci-lint > /dev/null; then \
        golangci-lint run; \
    else \
        echo "⚠️  golangci-lint not found, running go vet instead"; \
        go vet ./...; \
    fi

# Format code
format:
    @echo "✨ Formatting code..."
    go fmt ./...
    @echo "✅ Code formatted"

# Run benchmarks
bench:
    @echo "⚡ Running benchmarks..."
    go test -bench=. ./...

# Install development dependencies
setup-dev:
    @echo "🔧 Installing development dependencies..."
    @echo "Installing golangci-lint..."
    @go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    @echo "✅ Development setup complete"

# Show example usage
examples:
    @echo "📚 Spage Usage Examples"
    @echo "======================"
    @echo ""
    @echo "1. Generate code from playbook:"
    @echo "   just generate"
    @echo "   just quick-generate playbook.yaml output.go local"
    @echo ""
    @echo "2. Run playbook directly:"
    @echo "   just run-local  # Interactive"
    @echo "   just run-remote # Using remote package"
    @echo ""
    @echo "3. Development workflow:"
    @echo "   just build && ./spage generate --playbook my-playbook.yaml --output tasks.go"
    @echo "   go build -o runner tasks.go"
    @echo "   ./runner --inventory inventory.yaml"
    @echo ""
    @echo "4. Using remote package (no local install needed):"
    @echo "   go run github.com/AlexanderGrooff/spage@latest generate --playbook my-playbook.yaml --output tasks.go"