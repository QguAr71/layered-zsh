#!/bin/bash

# =============================================================================
# Layered ZSH Test Suite
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test functions
test_start() {
    echo -e "${BLUE}Testing: $1${NC}"
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
}

test_pass() {
    echo -e "${GREEN}✅ PASS${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

test_fail() {
    echo -e "${RED}❌ FAIL${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

test_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# =============================================================================
# STRUCTURE TESTS
# =============================================================================

echo -e "${BLUE}🔍 Testing Project Structure${NC}"

test_start "Core directory exists"
if [ -d "core" ]; then
    test_pass
else
    test_fail
fi

test_start "Security directory exists"
if [ -d "security" ]; then
    test_pass
else
    test_fail
fi

test_start "Productivity directory exists"
if [ -d "productivity" ]; then
    test_pass
else
    test_fail
fi

test_start "Core files exist"
if [ -f "core/init.zsh" ] && [ -f "core/aliases.zsh" ]; then
    test_pass
else
    test_fail
fi

test_start "Documentation exists"
if [ -f "README.md" ] && [ -f "LICENSE" ]; then
    test_pass
else
    test_fail
fi

# =============================================================================
# SYNTAX TESTS
# =============================================================================

echo -e "\n${BLUE}🔍 Testing Syntax${NC}"

test_start "Zsh syntax check for core files"
for file in core/*.zsh; do
    if zsh -n "$file" 2>/dev/null; then
        test_info "$file syntax OK"
    else
        test_fail
        test_info "$file has syntax errors"
        break
    fi
done

test_start "Shell syntax check for all .zsh files"
syntax_errors=0
for file in $(find . -name "*.zsh" -type f); do
    if ! zsh -n "$file" 2>/dev/null; then
        test_fail
        test_info "$file has syntax errors"
        syntax_errors=$((syntax_errors + 1))
    fi
done

if [ $syntax_errors -eq 0 ]; then
    test_pass
fi

# =============================================================================
# SECURITY TESTS
# =============================================================================

echo -e "\n${BLUE}🔍 Testing Security${NC}"

test_start "No hardcoded secrets"
if ! grep -r -i "ghp_[a-zA-Z0-9]\{36\}" . --exclude-dir=.git --exclude="*.md" 2>/dev/null; then
    test_pass
else
    test_fail
fi

test_start "No API keys"
if ! grep -r -i "sk-[a-zA-Z0-9]\{48\}" . --exclude-dir=.git --exclude="*.md" 2>/dev/null; then
    test_pass
else
    test_fail
fi

test_start "No passwords in code"
if ! grep -r -i "password.*=" . --exclude-dir=.git --exclude="*.md" --exclude="*.example" 2>/dev/null; then
    test_pass
else
    test_fail
fi

# =============================================================================
# FUNCTIONALITY TESTS
# =============================================================================

echo -e "\n${BLUE}🔍 Testing Functionality${NC}"

test_start "Core init loads without errors"
if zsh -c "source core/init.zsh" 2>/dev/null; then
    test_pass
else
    test_fail
fi

test_start "lhelp function exists"
if zsh -c "source core/init.zsh && command -v lhelp >/dev/null 2>&1" 2>/dev/null; then
    test_pass
else
    test_fail
fi

test_start "Layered mode is set"
if zsh -c "source core/init.zsh && [ -n \"\$LAYERED_MODE\" ]" 2>/dev/null; then
    test_pass
else
    test_fail
fi

test_start "Aliases are defined"
if zsh -c "source core/init.zsh && alias | grep -q 'lhelp'" 2>/dev/null; then
    test_pass
else
    test_fail
fi

# =============================================================================
# DOCUMENTATION TESTS
# =============================================================================

echo -e "\n${BLUE}🔍 Testing Documentation${NC}"

test_start "README has quick start"
if grep -q "## 🚀 Szybki Start" README.md; then
    test_pass
else
    test_fail
fi

test_start "README has requirements"
if grep -q "## 📋 Wymagania" README.md; then
    test_pass
else
    test_fail
fi

test_start "README has roadmap"
if grep -q "## 🛠️ Roadmap" README.md; then
    test_pass
else
    test_fail
fi

test_start "Quick start guide exists"
if [ -f "QUICK_START.md" ]; then
    test_pass
else
    test_fail
fi

# =============================================================================
# PERFORMANCE TESTS
# =============================================================================

echo -e "\n${BLUE}🔍 Testing Performance${NC}"

test_start "Startup performance"
start_time=$(date +%s%N)
if zsh -c "source core/init.zsh" 2>/dev/null; then
    end_time=$(date +%s%N)
    duration=$((($end_time - $start_time) / 1000000))
    if [ $duration -lt 5000 ]; then
        test_pass
        test_info "Startup time: ${duration}ms"
    else
        test_fail
        test_info "Startup time too slow: ${duration}ms"
    fi
else
    test_fail
fi

# =============================================================================
# INTEGRATION TESTS
# =============================================================================

echo -e "\n${BLUE}🔍 Testing Integration${NC}"

test_start "All layers load together"
if zsh -c "
    source core/init.zsh
    echo 'Core loaded'
    [ -n \"\$LAYERED_MODE\" ] && echo 'Mode set'
    command -v lhelp >/dev/null 2>&1 && echo 'Functions available'
" 2>/dev/null; then
    test_pass
else
    test_fail
fi

test_start "No conflicts between layers"
conflicts=0
for file in core/*.zsh security/*.zsh productivity/*.zsh; do
    if [ -f "$file" ]; then
        if ! zsh -n "$file" 2>/dev/null; then
            conflicts=$((conflicts + 1))
        fi
    fi
done

if [ $conflicts -eq 0 ]; then
    test_pass
else
    test_fail
    test_info "$conflicts files have conflicts"
fi

# =============================================================================
# RESULTS
# =============================================================================

echo -e "\n${BLUE}📊 Test Results${NC}"
echo -e "Total tests: $TESTS_TOTAL"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed!${NC}"
    exit 1
fi
