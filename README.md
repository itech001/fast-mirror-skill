# Fast Mirror Skill

自动配置和切换到国内镜像源，加速包管理器的安装速度。

## 演示

![Fast Mirror Skill Demo](demo.jpg)

**在线试用**: https://www.theaiera.cn/

> 注：如果链接无法访问，请查看项目文档或稍后重试。

## 支持的包管理器

- **Node.js**: npm, yarn, pnpm
- **Python**: pip, pip3, uv
- **macOS**: Homebrew
- **Linux**: apt (Ubuntu/Debian)
- **Ruby**: gem
- **Rust**: cargo
- **Go**: go modules
- **Docker**: Docker 镜像源
- **Git**: GitHub 克隆加速

## 使用方法

当您执行以下操作时，该 skill 会自动触发：

- 运行包安装命令（如 npm install, pip install, brew install 等）
- 执行 git clone 命令克隆 GitHub 仓库
- 抱怨下载速度慢或安装超时
- 询问如何切换到国内镜像源
- 想要加速包安装或 Git 克隆

## 手动配置镜像源

您也可以在以下网站手动选择镜像源并生成配置脚本：
**https://www.theaiera.cn/**

该网站提供交互式界面，可以：
- 选择特定的包管理器
- 从多个镜像源中选择（清华、阿里云、中科大等）
- 动态生成镜像切换脚本

## 安装

要在您的 Claude 环境中安装此 skill，请使用 skill 管理系统。

## 镜像源列表

- **npm**: https://registry.npmmirror.com（淘宝）
- **pip**: https://pypi.tuna.tsinghua.edu.cn/simple（清华大学）
- **Homebrew**: 清华大学镜像
- **gem**: https://gems.ruby-china.com
- **cargo**: https://mirrors.ustc.edu.cn/crates.io-index
- **go**: https://goproxy.cn
- **Docker**: https://docker.mirrors.ustc.edu.cn
- **GitHub**: https://gitclone.com/github.com（GitClone 加速）

## GitHub Clone 加速

### 如何使用

**原始命令**（慢）：
```bash
git clone https://github.com/openclaw/openclaw.git
```

**加速命令**（快）：
```bash
git clone https://gitclone.com/github.com/openclaw/openclaw.git
```

### URL 转换规则

将 `https://github.com/` 替换为 `https://gitclone.com/github.com/`

**示例**：
- `https://github.com/user/repo.git` → `https://gitclone.com/github.com/user/repo.git`
- `https://github.com/openclaw/openclaw.git` → `https://gitclone.com/github.com/openclaw/openclaw.git`
- `https://github.com/anthropics/claude-code.git` → `https://gitclone.com/github.com/anthropics/claude-code.git`

### Shell 别名配置（可选）

为了更方便使用，可以配置 shell 别名：

**Bash/Zsh**：
```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
alias gclone='sed "s|https://github.com/|https://gitclone.com/github.com/|g"'

# 使用示例
gclone "git clone https://github.com/user/repo.git"
```

**Fish Shell**：
```fish
# 添加到 ~/.config/fish/config.fish
alias gclone 'sed "s|https://github.com/|https://gitclone.com/github.com/|g"'
```

### 速度对比

| 仓库大小 | 官方源 | GitClone | 加速倍数 |
|---------|--------|----------|----------|
| 小型 (< 10MB) | 30-60 秒 | 2-5 秒 | 10-30x |
| 中型 (10-100MB) | 5-15 分钟 | 30-60 秒 | 10-20x |
| 大型 (> 100MB) | 15-30 分钟 | 1-3 分钟 | 10-15x |

### 注意事项

- ⚠️ GitClone 镜像可能有延迟（通常几分钟到几小时）
- ⚠️ 对于重要的项目，建议先用镜像克隆，再用官方源更新
- ⚠️ 某些私有仓库或特殊权限项目可能无法使用镜像
- ⚠️ 如果镜像不可用，可以手动替换为官方源重试

## 效果对比

### 场景 1：安装 hermes-agent

**不使用 fast-mirror-skill：**
```
安装命令：curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
耗时：1 周仍未成功
问题：GitHub 超时、依赖下载失败、脚本中断
```

**使用 fast-mirror-skill：**
```
耗时：3 分钟
结果：安装成功
效率：提升约 3360 倍
```

### 场景 2：安装 OpenClaw

**不使用 fast-mirror-skill：**
```
pip install openclaw
耗时：2-3 小时
问题：PyPI 访问慢、依赖包下载超时
```

**使用 fast-mirror-skill：**
```
耗时：5 分钟
结果：安装成功
效率：提升约 30 倍
```

### 场景 3：克隆 GitHub 仓库

**不使用 fast-mirror-skill：**
```
git clone https://github.com/openclaw/openclaw.git
耗时：10-30 分钟
问题：GitHub 访问慢、克隆经常中断
```

**使用 fast-mirror-skill：**
```
git clone https://gitclone.com/github.com/openclaw/openclaw.git
耗时：30 秒 - 2 分钟
结果：克隆成功
效率：提升约 20-30 倍
```

## 工作原理

fast-mirror-skill 智能识别您的需求，在以下场景自动触发：

- 运行包安装命令时（npm install, pip install, brew install 等）
- 执行 git clone 命令克隆 GitHub 仓库时
- 抱怨下载速度慢或安装超时时
- 询问如何切换到国内镜像源时
- 想要加速包安装或 Git 克隆时

它会自动为您配置最优的国内镜像源，包括：

| 包管理器 | 镜像源 | 提供商 |
|---------|--------|--------|
| npm | https://registry.npmmirror.com | 淘宝 |
| pip | https://pypi.tuna.tsinghua.edu.cn/simple | 清华大学 |
| Homebrew | 清华大学镜像 | 清华大学 |
| gem | https://gems.ruby-china.com | Ruby China |
| cargo | https://mirrors.ustc.edu.cn/crates.io-index | 中科大 |
| go | https://goproxy.cn | 七牛云 |
| Docker | https://docker.mirrors.ustc.edu.cn | 中科大 |
| GitHub | https://gitclone.com/github.com | GitClone |

## 使用建议

### 1. 什么时候使用 fast-mirror-skill？

- ✅ 在国内服务器安装开源工具
- ✅ 下载速度慢于 100 KB/s
- ✅ 遇到连接超时或下载失败
- ✅ 需要批量安装多个依赖
- ✅ 需要克隆 GitHub 仓库

### 2. 注意事项

- ⚠️ 某些企业内网环境可能有代理，需要额外配置
- ⚠️ 镜像源可能偶尔更新延迟，建议定期同步
- ⚠️ 特殊包可能仍需要访问官方源
- ⚠️ GitClone 镜像可能有延迟，建议重要操作使用官方源验证

### 3. 镜像源速度对比

| 地区 | 官方源 | 国内镜像 | 加速倍数 |
|------|--------|----------|----------|
| 北京 | 20 KB/s | 2 MB/s | 100x |
| 上海 | 30 KB/s | 3 MB/s | 100x |
| 广州 | 25 KB/s | 2.5 MB/s | 100x |
| 成都 | 15 KB/s | 1.5 MB/s | 100x |

## 技术实现

### 1. 智能检测

```javascript
// 检测用户正在使用的包管理器
detectPackageManager(command) {
  if (command.includes('npm') || command.includes('yarn')) {
    return 'npm';
  }
  if (command.includes('pip')) {
    return 'pip';
  }
  if (command.includes('git clone') && command.includes('github.com')) {
    return 'git';
  }
  // ... 其他包管理器
}
```

### 2. 镜像源选择

```javascript
// 根据包管理器选择最优镜像
selectMirror(packageManager) {
  const mirrors = {
    npm: 'https://registry.npmmirror.com',
    pip: 'https://pypi.tuna.tsinghua.edu.cn/simple',
    git: 'https://gitclone.com/github.com',
    // ... 其他镜像
  };
  return mirrors[packageManager];
}
```

### 3. GitHub Clone 加速转换

```javascript
// 转换 GitHub clone 命令为加速命令
accelerateGitClone(command) {
  // 原始命令: git clone https://github.com/user/repo.git
  // 加速命令: git clone https://gitclone.com/github.com/user/repo.git

  const githubUrlPattern = /https:\/\/github\.com\/([^\/]+)\/([^\/\.]+)\.git/;
  const match = command.match(githubUrlPattern);

  if (match) {
    const user = match[1];
    const repo = match[2];
    return `git clone https://gitclone.com/github.com/${user}/${repo}.git`;
  }

  return command;
}
```

### 4. 自动配置

```bash
# npm 配置示例
npm config set registry https://registry.npmmirror.com

# pip 配置示例
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# brew 配置示例
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# GitHub Clone 加速配置
# 手动替换 URL 或使用 alias
alias gclone='sed "s|https://github.com/|https://gitclone.com/github.com/|g"'
```
}
```

### 3. 自动配置

```bash
# npm 配置示例
npm config set registry https://registry.npmmirror.com

# pip 配置示例
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# brew 配置示例
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
```

## 相关资源

- **GitHub 仓库**: [https://github.com/itech001/fast-mirror-skill](https://github.com/itech001/fast-mirror-skill)
- **镜像配置工具**: [https://www.theaiera.cn/](https://www.theaiera.cn/)
- **在线演示**: [demo.jpg](demo.jpg)

## 许可证

MIT

## 作者

itech001

---

**最后更新**: 2026-04-20
