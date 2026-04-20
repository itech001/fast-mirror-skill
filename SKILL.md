---
name: fast-mirror-skill
description: Automatically configure and switch to domestic mirror sources for package managers to speed up installations. Use this skill whenever the user is installing packages, dependencies, or programs — especially when they mention npm install, pip install, yarn install, brew install, apt install, gem install, cargo install, go get, or any other package installation commands. Also trigger when the user complains about slow download speeds, slow installations, network issues, or when they explicitly ask about using Chinese/domestic mirrors, mirror sources, or acceleration for package installations.
---

# Fast Mirror Skill

This skill helps users speed up package installations by automatically detecting package managers and switching to fast domestic mirror sources in China.

## When to Use

Trigger this skill when:
- User runs or wants to run any package installation command (npm, pip, yarn, pnpm, brew, apt, gem, cargo, go get, docker, etc.)
- User complains about slow download speeds or installation timeouts
- User explicitly mentions switching to Chinese/domestic mirror sources
- User wants to accelerate package installations
- User is setting up a new environment or installing project dependencies

## Supported Package Managers

This skill supports the following package managers with pre-configured domestic mirror sources:

- **Node.js**: npm, yarn, pnpm
- **Python**: pip, pip3
- **macOS**: Homebrew
- **Linux**: apt (Ubuntu/Debian), yum (CentOS/RHEL)
- **Ruby**: gem
- **Rust**: cargo
- **Go**: go modules
- **Docker**: Docker registry mirror

## Workflow

### Step 1: Detect Package Managers

Analyze the user's input to identify which package managers they need:

- Look for explicit commands (npm install, pip install, brew install, etc.)
- Check for package.json, requirements.txt, Gemfile, go.mod, Cargo.toml files in the current directory
- Ask the user if needed: "What type of packages are you installing? (npm, pip, brew, etc.)"

### Step 2: Generate Mirror Switch Script

Create a shell script that switches the detected package managers to domestic mirror sources.

The script should:
- Only include the package managers the user actually needs
- Use reliable and fast mirror sources (Tsinghua, Aliyun, Tencent, USTC, etc.)
- Be safe and reversible (restore original sources if needed)
- Print clear status messages

Use the bundled script `scripts/generate_mirror_script.sh` if available, or generate the script inline with these mirror configurations:

```bash
#!/bin/bash

# npm mirror
npm config set registry https://registry.npmmirror.com

# pip mirror
mkdir -p ~/.pip
cat > ~/.pip/pip.conf << 'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF

# Homebrew mirror (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
fi

# Docker mirror
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF

# And so on for other package managers...
```

### Step 3: Source the Mirror Script

Instruct the user to source the generated script:

```bash
source /path/to/mirror_switch.sh
```

Or execute it directly and then run the user's installation command:

```bash
. /path/to/mirror_switch.sh && <user's installation command>
```

**Important**: Explain that this sets environment variables for the current shell session. For permanent changes, the script should be added to shell configuration files (`.bashrc`, `.zshrc`, etc.).

### Step 4: Execute Installation

Run the user's original installation command after the mirror sources are configured.

## Mirror Source Recommendations

Use these reliable mirror sources (in order of preference):

- **npm**: `https://registry.npmmirror.com` (Taobao)
- **pip**: `https://pypi.tuna.tsinghua.edu.cn/simple` (Tsinghua)
- **Homebrew**: Tsinghua mirrors for brew.git, homebrew-core, bottles
- **apt**: Tsinghua or Aliyun mirrors
- **gem**: `https://gems.ruby-china.com`
- **cargo**: `https://mirrors.ustc.edu.cn/crates.io-index`
- **go**: `https://goproxy.cn` or `https://goproxy.io`
- **Docker**: `https://docker.mirrors.ustc.edu.cn`

## Advanced Usage

### Manual Mirror Selection

Inform the user that they can also manually select mirrors and generate scripts at:
**https://www.theaiera.cn/**

This website provides an interactive interface to:
- Select specific package managers
- Choose from multiple mirror sources
- Dynamically generate mirror switch scripts
- Copy and use the generated scripts

### Permanent Configuration

For permanent mirror configuration, guide users to add mirror settings to their shell configuration files or package manager config files:

```bash
# For npm
echo 'export npm_config_registry=https://registry.npmmirror.com' >> ~/.bashrc

# For pip
# ~/.pip/pip.conf is already permanent

# For Homebrew
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.zshrc
```

### Reverting to Official Sources

Provide instructions to revert back to official sources if needed:

```bash
# npm
npm config set registry https://registry.npmjs.org

# pip
rm ~/.pip/pip.conf

# Homebrew
unset HOMEBREW_BREW_GIT_REMOTE HOMEBREW_CORE_GIT_REMOTE HOMEBREW_BOTTLE_DOMAIN
```

## Error Handling

If mirror sources fail:
1. Inform the user that the mirror might be temporarily unavailable
2. Suggest trying an alternative mirror source
3. Fall back to official sources if needed
4. Provide troubleshooting tips (check network, try different mirror, etc.)

## Example Interactions

**Example 1:**
User: "I need to install a new node project, npm install is so slow"
Action: Generate npm mirror script, source it, then run npm install

**Example 2:**
User: "pip install pandas is timing out"
Action: Generate pip mirror script, source it, then run pip install pandas

**Example 3:**
User: "How do I speed up brew install?"
Action: Generate Homebrew mirror script, explain how to source it, then run brew install

**Example 4:**
User: "I'm setting up a new development environment and need to install all dependencies"
Action: Check for package.json, requirements.txt, Gemfile, etc., generate appropriate mirror scripts for all detected package managers, source them, then run installation commands

## Notes

- Always ask for clarification if it's unclear which package manager the user needs
- Prioritize speed and reliability when selecting mirror sources
- Be conservative: only configure the package managers the user actually needs
- Explain what the script does before sourcing it
- Make it clear whether the changes are temporary (current session) or permanent
