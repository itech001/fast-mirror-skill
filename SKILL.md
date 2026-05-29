---
name: fast-mirror-skill
description: 自动配置并切换国内镜像源以加速包管理器安装。当用户进行包/依赖安装（如 npm install、pip install、yarn install、brew install、apt install、gem install、cargo install、go get 等），或抱怨下载慢、安装超时、网络问题，或明确询问国内镜像源时使用此技能。
---

# 快速镜像源技能

本技能帮助用户通过自动检测包管理器并切换至国内高速镜像源，加速包安装过程。

## 何时使用

当以下情况时触发此技能：
- 用户运行或准备运行任何包安装命令（npm、pip、yarn、pnpm、brew、apt、gem、cargo、go get、docker 等）
- 用户抱怨下载速度慢或安装超时
- 用户明确提及切换国内镜像源
- 用户想加速包安装
- 用户正在搭建新环境或安装项目依赖

## 支持的包管理器

本技能支持以下包管理器，并预配置了国内镜像源：

- **Node.js**: npm, yarn, pnpm
- **Python**: pip, pip3
- **macOS**: Homebrew
- **Linux**: apt (Ubuntu/Debian), yum (CentOS/RHEL)
- **Ruby**: gem
- **Rust**: cargo
- **Go**: go modules
- **Docker**: Docker registry mirror

## 工作流程

### 第一步：检测包管理器

分析用户输入，识别其需要的包管理器：

- 查找明确命令（npm install、pip install、brew install 等）
- 检查当前目录是否存在 package.json、requirements.txt、Gemfile、go.mod、Cargo.toml 等文件
- 必要时询问用户："您要安装什么类型的包？（npm、pip、brew 等）"

### 第二步：生成镜像切换脚本

创建一个 shell 脚本，将检测到的包管理器切换至国内镜像源。

脚本应：
- 仅包含用户实际需要的包管理器
- 使用可靠高速的镜像源（清华、阿里、腾讯、中科大等）
- 安全可靠且可逆（必要时可恢复官方源）
- 输出清晰的提示信息

使用配套的 `scripts/generate_mirror_script.sh`（如有），或按以下镜像配置内联生成脚本：

```bash
#!/bin/bash

# npm 镜像
npm config set registry https://registry.npmmirror.com

# pip 镜像
mkdir -p ~/.pip
cat > ~/.pip/pip.conf << 'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF

# Homebrew 镜像（macOS）
if [[ "$OSTYPE" == "darwin"* ]]; then
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
fi

# Docker 镜像
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"]
}
EOF

# 其他包管理器依此类推...
```

### 第三步：加载镜像脚本

指导用户加载生成的脚本：

```bash
source /path/to/mirror_switch.sh
```

或直接执行后再运行用户的安装命令：

```bash
. /path/to/mirror_switch.sh && <用户的安装命令>
```

**注意**：此操作仅设置当前 shell 会话的环境变量。如需永久生效，应将脚本添加到 shell 配置文件（`.bashrc`、`.zshrc` 等）中。

### 第四步：执行安装

镜像源配置完成后，运行用户原始的安装命令。

## 镜像源推荐

按优先级使用以下可靠镜像源：

- **npm**: `https://registry.npmmirror.com`（淘宝）
- **pip**: `https://pypi.tuna.tsinghua.edu.cn/simple`（清华）
- **Homebrew**: 清华镜像（brew.git、homebrew-core、bottles）
- **apt**: 清华或阿里镜像
- **gem**: `https://gems.ruby-china.com`
- **cargo**: `https://mirrors.ustc.edu.cn/crates.io-index`
- **go**: `https://goproxy.cn` 或 `https://goproxy.io`
- **Docker**: `https://docker.mirrors.ustc.edu.cn`

## 高级用法

### 手动选择镜像

用户也可以通过以下网站手动选择镜像并生成脚本：
**https://www.theaiera.cn/mirrors**

该网站提供交互式界面，可：
- 选择特定包管理器
- 从多个镜像源中挑选
- 动态生成镜像切换脚本
- 复制并使用生成的脚本

### 永久配置

如需永久配置镜像源，指导用户将镜像设置添加到 shell 配置文件或包管理器配置文件中：

```bash
# 对于 npm
echo 'export npm_config_registry=https://registry.npmmirror.com' >> ~/.bashrc

# 对于 pip
# ~/.pip/pip.conf 已为永久配置

# 对于 Homebrew
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles' >> ~/.zshrc
```

### 恢复官方源

如需恢复官方源：

```bash
# npm
npm config set registry https://registry.npmjs.org

# pip
rm ~/.pip/pip.conf

# Homebrew
unset HOMEBREW_BREW_GIT_REMOTE HOMEBREW_CORE_GIT_REMOTE HOMEBREW_BOTTLE_DOMAIN
```

## 错误处理

如果镜像源失效：
1. 告知用户镜像可能暂时不可用
2. 建议尝试其他镜像源
3. 必要时回退至官方源
4. 提供排查技巧（检查网络、尝试不同镜像等）

## 交互示例

**示例 1：**
用户："我要安装一个新 node 项目，npm install 太慢了"
操作：生成 npm 镜像脚本，加载后执行 npm install

**示例 2：**
用户："pip install pandas 超时了"
操作：生成 pip 镜像脚本，加载后执行 pip install pandas

**示例 3：**
用户："如何加速 brew install？"
操作：生成 Homebrew 镜像脚本，说明如何加载，然后执行 brew install

**示例 4：**
用户："我正在搭建新开发环境，需要安装所有依赖"
操作：检查 package.json、requirements.txt、Gemfile 等，为所有检测到的包管理器生成对应的镜像脚本，加载后执行安装命令

## 注意事项

- 如不确定用户需要哪个包管理器，务必先询问确认
- 选择镜像源时优先速度和可靠性
- 保守操作：仅配置用户实际需要的包管理器
- 加载脚本前先解释其作用
- 明确说明更改是临时的（当前会话）还是永久的
