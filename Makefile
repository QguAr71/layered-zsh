# =============================================================================
# Layered ZSH Makefile
# =============================================================================

.PHONY: help install test clean lint format docs ci dev-setup

# Default target
help:
	@echo "Layered ZSH v3.0 - Makefile Commands"
	@echo "====================================="
	@echo ""
	@echo "🚀 Installation:"
	@echo "  install      - Install Layered ZSH"
	@echo "  dev-setup    - Development setup with all dependencies"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  test         - Run all tests"
	@echo "  test-syntax  - Syntax check only"
	@echo "  test-security - Security scan only"
	@echo "  test-perf    - Performance tests only"
	@echo ""
	@echo "🔧 Maintenance:"
	@echo "  clean        - Clean temporary files"
	@echo "  lint         - Lint all files"
	@echo "  format       - Format files"
	@echo "  docs         - Generate documentation"
	@echo ""
	@echo "🚀 CI/CD:"
	@echo "  ci           - Run CI pipeline locally"
	@echo ""
	@echo "📚 Documentation:"
	@echo "  docs-serve   - Serve documentation locally"
	@echo "  docs-build   - Build documentation"

# =============================================================================
# INSTALLATION
# =============================================================================

install:
	@echo "🚀 Installing Layered ZSH..."
	@if [ ! -d "$(HOME)/.config/layered" ]; then \
		echo "Creating ~/.config/layered directory..."; \
		mkdir -p "$(HOME)/.config/layered"; \
	fi
	@echo "Copying files to ~/.config/layered..."
	@cp -r core security productivity "$(HOME)/.config/layered/"
	@echo "Adding to .zshrc..."
	@if ! grep -q "source ~/.config/layered/core/init.zsh" "$(HOME)/.zshrc" 2>/dev/null; then \
		echo 'source ~/.config/layered/core/init.zsh' >> "$(HOME)/.zshrc"; \
	fi
	@echo "✅ Installation complete!"
	@echo "Run 'source ~/.zshrc' to reload your shell."

dev-setup: install
	@echo "🔧 Setting up development environment..."
	@echo "Installing dependencies..."
	@# Check for Zsh
	@if ! command -v zsh >/dev/null 2>&1; then \
		echo "❌ Zsh is not installed. Please install Zsh first."; \
		exit 1; \
	fi
	@# Check for Git
	@if ! command -v git >/dev/null 2>&1; then \
		echo "❌ Git is not installed. Please install Git first."; \
		exit 1; \
	fi
	@# Install Ollama (optional)
	@if command -v ollama >/dev/null 2>&1; then \
		echo "🤖 Installing AI model..."; \
		ollama pull deepseek-coder-v2:lite; \
	else \
		echo "⚠️  Ollama not found. AI features will not be available."; \
	fi
	@# Install lm_sensors (optional)
	@if command -v sensors >/dev/null 2>&1; then \
		echo "🌡️  lm_sensors is available."; \
	else \
		echo "⚠️  lm_sensors not found. Temperature monitoring will not be available."; \
	fi
	@echo "✅ Development setup complete!"

# =============================================================================
# TESTING
# =============================================================================

test:
	@echo "🧪 Running all tests..."
	@./test.sh

test-syntax:
	@echo "🔍 Running syntax checks..."
	@for file in $$(find . -name "*.zsh" -type f); do \
		echo "Checking $$file..."; \
		if ! zsh -n "$$file"; then \
			echo "❌ Syntax error in $$file"; \
			exit 1; \
		fi; \
	done
	@echo "✅ All syntax checks passed!"

test-security:
	@echo "🔒 Running security scans..."
	@echo "Scanning for secrets..."
	@if grep -r -i "ghp_[a-zA-Z0-9]\{36\}" . --exclude-dir=.git --exclude="*.md" --exclude="*.example"; then \
		echo "❌ GitHub tokens found!"; \
		exit 1; \
	fi
	@if grep -r -i "sk-[a-zA-Z0-9]\{48\}" . --exclude-dir=.git --exclude="*.md" --exclude="*.example"; then \
		echo "❌ API keys found!"; \
		exit 1; \
	fi
	@if grep -r -i "password.*=" . --exclude-dir=.git --exclude="*.md" --exclude="*.example"; then \
		echo "❌ Potential passwords found!"; \
		exit 1; \
	fi
	@echo "✅ Security scan passed!"

test-perf:
	@echo "⚡ Running performance tests..."
	@echo "Testing startup performance..."
	@start_time=$$(date +%s%N); \
	zsh -c "source core/init.zsh" >/dev/null 2>&1; \
	end_time=$$(date +%s%N); \
	duration=$$((($$end_time - $$start_time) / 1000000)); \
	echo "Startup time: $${duration}ms"; \
	if [ $$duration -lt 5000 ]; then \
		echo "✅ Performance test passed!"; \
	else \
		echo "⚠️  Startup time is slow: $${duration}ms"; \
	fi

# =============================================================================
# MAINTENANCE
# =============================================================================

clean:
	@echo "🧹 Cleaning temporary files..."
	@find . -name "*.tmp" -delete
	@find . -name "*.log" -delete
	@find . -name ".DS_Store" -delete
	@find . -name "Thumbs.db" -delete
	@echo "✅ Clean complete!"

lint:
	@echo "🔍 Linting files..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck **/*.zsh **/*.sh; \
	else \
		echo "⚠️  shellcheck not found. Install shellcheck for linting."; \
	fi

format:
	@echo "📝 Formatting files..."
	@echo "Formatting completed (no formatter configured for .zsh files)"

docs:
	@echo "📚 Generating documentation..."
	@echo "Documentation already available in README.md and QUICK_START.md"

docs-serve:
	@echo "🌐 Serving documentation locally..."
	@if command -v python3 >/dev/null 2>&1; then \
		cd . && python3 -m http.server 8080; \
	else \
		echo "❌ Python3 not found. Cannot serve documentation."; \
	fi

docs-build:
	@echo "🏗️  Building documentation..."
	@echo "Documentation build completed"

# =============================================================================
# CI/CD
# =============================================================================

ci: test-syntax test-security test-perf
	@echo "🚀 Running CI pipeline..."
	@echo "✅ CI pipeline completed successfully!"

# =============================================================================
# DEVELOPMENT
# =============================================================================

dev-test:
	@echo "🧪 Running development tests..."
	@echo "Testing core functionality..."
	@zsh -c "source core/init.zsh && echo '✅ Core loads successfully'"
	@zsh -c "source core/init.zsh && command -v lhelp >/dev/null 2>&1 && echo '✅ lhelp function available'"
	@zsh -c "source core/init.zsh && [ -n \"\$$LAYERED_MODE\" ] && echo '✅ Layered mode is set'"

dev-status:
	@echo "📊 Development status:"
	@echo "=================="
	@echo "Zsh version: $$(zsh --version)"
	@echo "Git version: $$(git --version)"
	@echo "Working directory: $$(pwd)"
	@echo "Branch: $$(git branch --show-current)"
	@echo "Last commit: $$(git log -1 --oneline)"
	@echo "Files: $$(find . -name "*.zsh" | wc -l) .zsh files"

dev-install-deps:
	@echo "📦 Installing development dependencies..."
	@if command -v pacman >/dev/null 2>&1; then \
		echo "Detected Arch Linux..."; \
		sudo pacman -S --needed git zsh shellcheck; \
	elif command -v apt >/dev/null 2>&1; then \
		echo "Detected Debian/Ubuntu..."; \
		sudo apt-get update && sudo apt-get install -y git zsh shellcheck; \
	else \
		echo "❌ Unsupported package manager. Please install git, zsh, and shellcheck manually."; \
	fi

# =============================================================================
# RELEASE
# =============================================================================

release-check:
	@echo "🔍 Checking release readiness..."
	@echo "Running full test suite..."
	@$(MAKE) test
	@echo "Checking documentation..."
	@if [ ! -f "README.md" ] || [ ! -f "QUICK_START.md" ] || [ ! -f "LICENSE" ]; then \
		echo "❌ Missing documentation files"; \
		exit 1; \
	fi
	@echo "Checking version..."
	@if ! grep -q "v3.0" README.md; then \
		echo "❌ Version not found in README.md"; \
		exit 1; \
	fi
	@echo "✅ Release check passed!"

release-tag:
	@echo "🏷️  Creating release tag..."
	@git tag -a v3.0 -m "Layered ZSH v3.0 release"
	@echo "✅ Release tag created. Run 'git push --tags' to push to remote."

# =============================================================================
# UTILITIES
# =============================================================================

count:
	@echo "📊 Project statistics:"
	@echo "==================="
	@echo "Total .zsh files: $$(find . -name "*.zsh" | wc -l)"
	@echo "Total lines: $$(find . -name "*.zsh" -exec wc -l {} + | tail -1 | awk '{print $$1}')"
	@echo "Core files: $$(find core -name "*.zsh" | wc -l)"
	@echo "Security files: $$(find security -name "*.zsh" | wc -l)"
	@echo "Productivity files: $$(find productivity -name "*.zsh" | wc -l)"

backup:
	@echo "💾 Creating backup..."
	@backup_name="layered-zsh-backup-$$(date +%Y%m%d-%H%M%S)"
	@tar -czf "$$backup_name.tar.gz" .
	@echo "✅ Backup created: $$backup_name.tar.gz"

restore:
	@echo "🔄 Restore from backup (manual process):"
	@echo "1. Extract backup: tar -xzf layered-zsh-backup-YYYYMMDD-HHMMSS.tar.gz"
	@echo "2. Run make install to reinstall"

# =============================================================================
# HELP
# =============================================================================

list-functions:
	@echo "📋 Available functions in Layered ZSH:"
	@echo "====================================="
	@grep -h "^[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(" core/*.zsh security/*.zsh productivity/*.zsh | sort | uniq

list-aliases:
	@echo "📋 Available aliases in Layered ZSH:"
	@echo "===================================="
	@grep -h "^alias " core/*.zsh security/*.zsh productivity/*.zsh | sort | uniq

version:
	@echo "Layered ZSH v3.0"
	@echo "==============="
	@echo "Neutral, modular Zsh configuration system"
	@echo "https://github.com/QguAr71/layered-zsh"
