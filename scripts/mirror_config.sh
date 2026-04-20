#!/bin/bash

# Mirror source configurations for various package managers
# This script can be sourced to switch to fast domestic mirrors in China

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to configure npm/yarn/pnpm mirrors
configure_nodejs() {
    if command -v npm &> /dev/null; then
        print_status "Configuring npm mirror..."
        npm config set registry https://registry.npmmirror.com
        print_status "npm registry set to: $(npm config get registry)"
    fi

    if command -v yarn &> /dev/null; then
        print_status "Configuring yarn mirror..."
        yarn config set registry https://registry.npmmirror.com
        print_status "yarn registry set to: $(yarn config get registry)"
    fi

    if command -v pnpm &> /dev/null; then
        print_status "Configuring pnpm mirror..."
        pnpm config set registry https://registry.npmmirror.com
        print_status "pnpm registry set to: $(pnpm config get registry)"
    fi
}

# Function to configure pip mirror
configure_python() {
    if command -v pip &> /dev/null || command -v pip3 &> /dev/null; then
        print_status "Configuring pip mirror..."
        mkdir -p ~/.pip
        cat > ~/.pip/pip.conf << 'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
timeout = 120
EOF
        print_status "pip mirror configured to use Tsinghua TUNA"
    fi
}

# Function to configure Homebrew mirror
configure_homebrew() {
    if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
        print_status "Configuring Homebrew mirror..."
        export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
        export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

        # Update shell environment
        if [[ -n "$ZSH_VERSION" ]]; then
            echo "export HOMEBREW_BREW_GIT_REMOTE=\"$HOMEBREW_BREW_GIT_REMOTE\"" >> ~/.zshrc
            echo "export HOMEBREW_CORE_GIT_REMOTE=\"$HOMEBREW_CORE_GIT_REMOTE\"" >> ~/.zshrc
            echo "export HOMEBREW_BOTTLE_DOMAIN=\"$HOMEBREW_BOTTLE_DOMAIN\"" >> ~/.zshrc
        elif [[ -n "$BASH_VERSION" ]]; then
            echo "export HOMEBREW_BREW_GIT_REMOTE=\"$HOMEBREW_BREW_GIT_REMOTE\"" >> ~/.bashrc
            echo "export HOMEBREW_CORE_GIT_REMOTE=\"$HOMEBREW_CORE_GIT_REMOTE\"" >> ~/.bashrc
            echo "export HOMEBREW_BOTTLE_DOMAIN=\"$HOMEBREW_BOTTLE_DOMAIN\"" >> ~/.bashrc
        fi

        print_status "Homebrew mirror configured (run 'brew update' to apply)"
    fi
}

# Function to configure apt mirror (Ubuntu/Debian)
configure_apt() {
    if [[ -f /etc/debian_version ]] && command -v apt &> /dev/null; then
        print_warning "apt mirror configuration requires sudo privileges"
        print_warning "Please run the following commands manually or use theaiera.cn for apt mirror setup"
        print_warning "For Ubuntu: https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/"
        print_warning "For Debian: https://mirrors.tuna.tsinghua.edu.cn/help/debian/"
    fi
}

# Function to configure gem mirror
configure_gem() {
    if command -v gem &> /dev/null; then
        print_status "Configuring Ruby gem mirror..."
        gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ 2>/dev/null || true
        print_status "gem sources: $(gem sources -l)"
    fi
}

# Function to configure cargo mirror
configure_cargo() {
    if command -v cargo &> /dev/null; then
        print_status "Configuring Rust cargo mirror..."
        mkdir -p ~/.cargo
        cat > ~/.cargo/config << 'EOF'
[source.crates-io]
replace-with = 'ustc'

[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"

[net]
git-fetch-with-cli = true
EOF
        print_status "cargo mirror configured to use USTC"
    fi
}

# Function to configure go modules mirror
configure_go() {
    if command -v go &> /dev/null; then
        print_status "Configuring Go modules mirror..."
        export GOPROXY=https://goproxy.cn,direct
        export GO111MODULE=on

        if [[ -n "$ZSH_VERSION" ]]; then
            echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.zshrc
            echo 'export GO111MODULE=on' >> ~/.zshrc
        elif [[ -n "$BASH_VERSION" ]]; then
            echo 'export GOPROXY=https://goproxy.cn,direct' >> ~/.bashrc
            echo 'export GO111MODULE=on' >> ~/.bashrc
        fi

        print_status "Go modules mirror configured to use goproxy.cn"
    fi
}

# Function to configure docker registry mirror
configure_docker() {
    if command -v docker &> /dev/null; then
        print_warning "Docker mirror configuration requires sudo and may need Docker daemon restart"
        print_warning "Please run the following commands manually:"
        print_warning "sudo mkdir -p /etc/docker"
        print_warning 'sudo tee /etc/docker/daemon.json <<EOF'
        print_warning '{'
        print_warning '  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]'
        print_warning '}'
        print_warning 'EOF'
        print_warning "sudo systemctl restart docker  # or restart Docker Desktop"
    fi
}

# Main function to configure selected package managers
configure_mirrors() {
    local package_managers=("$@")
    local configured=false

    if [[ ${#package_managers[@]} -eq 0 ]]; then
        print_warning "No package managers specified. Usage: source this script and call configure_mirrors npm pip brew gem cargo go docker"
        return 1
    fi

    print_status "Configuring mirrors for: ${package_managers[*]}"

    for pm in "${package_managers[@]}"; do
        case "$pm" in
            npm|yarn|pnpm|node|nodejs)
                configure_nodejs
                configured=true
                ;;
            pip|python)
                configure_python
                configured=true
                ;;
            brew|homebrew)
                configure_homebrew
                configured=true
                ;;
            apt)
                configure_apt
                configured=true
                ;;
            gem|ruby)
                configure_gem
                configured=true
                ;;
            cargo|rust)
                configure_cargo
                configured=true
                ;;
            go|golang)
                configure_go
                configured=true
                ;;
            docker)
                configure_docker
                configured=true
                ;;
            *)
                print_warning "Unknown package manager: $pm"
                ;;
        esac
    done

    if $configured; then
        print_status "Mirror configuration completed!"
        print_status "Note: Some changes are for current session only. For permanent changes, restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
    fi
}

# Export functions so they can be called after sourcing
export -f configure_nodejs
export -f configure_python
export -f configure_homebrew
export -f configure_apt
export -f configure_gem
export -f configure_cargo
export -f configure_go
export -f configure_docker
export -f configure_mirrors

print_status "Mirror configuration functions loaded. Use: configure_mirrors <package_manager1> <package_manager2> ..."
print_status "Supported: npm, pip, brew, apt, gem, cargo, go, docker"
