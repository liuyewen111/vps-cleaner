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

## 📦 支持系统

- Debian / Ubuntu 系列
- （未来计划：支持 CentOS / Alpine）

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
