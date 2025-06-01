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

## 🖥️ 使用方法

**一键运行（推荐）：**

```bash
bash <(curl -sL https://raw.githubusercontent.com/liuyewen111/vps-cleaner/main/clean.sh)
```
