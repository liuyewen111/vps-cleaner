# VPS Cleaner 一键清理脚本

🧹 一个简单实用的一键脚本，用于自动清理 VPS 上的各种缓存、日志、旧内核和安装包残留，释放磁盘空间，保持系统干净整洁。

## ✨ 功能特点

- 自动更新系统缓存信息
- 清理无用依赖包 (`apt autoremove`)
- 删除 APT 缓存 (`apt clean`)
- 清空 `/var/cache/`, `/var/tmp/`, `/var/log` 日志文件
- 删除常见安装包和压缩包（`.zip`, `.tar.gz`, `.iso`, `.sh` 等）
- 清除旧内核（保留当前正在使用的）
- 清理 Systemd 日志（`journalctl --vacuum-time=1d`）
- 可选：清理 snap 缓存

## 脚本支持的 Linux 系统及包管理器

| Linux 发行版 / 系统            | 识别标识 `$ID` 或 `$ID_LIKE`   | 包管理器                   | 清理函数名         |
| ------------------------- | ------------------------- | ---------------------- | ------------- |
| Ubuntu                    | ubuntu                    | apt                    | clean\_apt    |
| Debian                    | debian                    | apt                    | clean\_apt    |
| Debian 衍生（Linux Mint等）    | 可能 `$ID_LIKE` 包含 `debian` | apt                    | clean\_apt    |
| CentOS                    | centos                    | yum                    | clean\_yum    |
| RHEL (Red Hat Enterprise) | rhel                      | yum                    | clean\_yum    |
| Fedora                    | fedora                    | dnf                    | clean\_dnf    |
| Alpine                    | alpine                    | apk                    | clean\_apk    |
| Arch Linux                | arch                      | pacman                 | clean\_pacman |
| 其他未知系统                    | 通过检测可用包管理器执行相应清理          | apt/yum/dnf/pacman/apk | 对应清理函数        |

## 具体包管理器说明

* **apt** — 主要用于 Debian、Ubuntu 及其衍生系统
* **yum** — 主要用于 CentOS 7 及之前版本、RHEL 7
* **dnf** — Fedora、CentOS 8 及 RHEL 8 之后版本的包管理器
* **pacman** — Arch Linux 和部分基于 Arch 的发行版
* **apk** — Alpine Linux

## 小众或未明确识别的系统

脚本中有最后 fallback（回退）判断，会检测系统中是否存在以上包管理器之一，自动调用对应清理命令，例如：

* 如果检测到 `apt` 命令存在则调用 `clean_apt`
* 如果检测到 `yum` 命令存在则调用 `clean_yum`
* 依此类推

这样即使是某些小众发行版，只要安装了上述包管理器之一，都能得到相应的支持。

## 🖥️ 使用方法

**一键运行（推荐）：**

```bash
bash <(curl -sL https://raw.githubusercontent.com/liuyewen111/vps-cleaner/main/clean.sh)
```

## ⚠️ 注意事项

- 脚本将自动清理常见缓存和安装包，如有重要文件，请提前备份
- 推荐定期运行以保持 VPS 干净整洁
- 脚本默认清理最近 1 天以前的日志（journalctl --vacuum-time=1d）

## 📄 开源协议

本项目使用 MIT License 开源，你可以自由使用和修改。
