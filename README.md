# Fast Mirror Skill

Automatically configure and switch to domestic mirror sources for package managers to speed up installations in China.

## Demo

![Fast Mirror Skill Demo](demo.jpg)

**Try it online**: https://www.theaiera.cn/

## Supported Package Managers

- **Node.js**: npm, yarn, pnpm
- **Python**: pip, pip3, uv
- **macOS**: Homebrew
- **Linux**: apt (Ubuntu/Debian)
- **Ruby**: gem
- **Rust**: cargo
- **Go**: go modules
- **Docker**: Docker registry mirror
- **GitHub**: GitHub mirror (if applicable)

## How to Use

This skill automatically triggers when you:
- Run package installation commands (npm install, pip install, brew install, etc.)
- Complain about slow download speeds or installation timeouts
- Ask about switching to Chinese/domestic mirror sources
- Want to accelerate package installations

## Manual Mirror Configuration

You can also manually select mirrors and generate scripts at:
**https://www.theaiera.cn/**

This website provides an interactive interface to:
- Select specific package managers
- Choose from multiple mirror sources (Tsinghua, Aliyun, USTC, etc.)
- Dynamically generate mirror switch scripts

## Installation

To install this skill, use the skill management system in your Claude environment.

## Mirror Sources

- **npm**: https://registry.npmmirror.com (Taobao)
- **pip**: https://pypi.tuna.tsinghua.edu.cn/simple (Tsinghua)
- **Homebrew**: Tsinghua mirrors
- **gem**: https://gems.ruby-china.com
- **cargo**: https://mirrors.ustc.edu.cn/crates.io-index
- **go**: https://goproxy.cn
- **Docker**: https://docker.mirrors.ustc.edu.cn
