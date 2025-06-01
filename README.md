# VPS Cleaner — 多系统一键清理脚本

## 简介

VPS Cleaner 是一个支持多种 Linux 发行版的远程一键清理脚本。  
它帮助你快速清理系统缓存、无用软件包、旧内核、日志及下载残留，释放磁盘空间，保持 VPS 轻快稳定。

支持包括但不限于：Debian、Ubuntu、CentOS、Fedora、Alpine、Arch Linux 等主流及小众系统。

## 使用方法

直接在你的 VPS 终端执行以下命令即可一键下载安装并运行清理脚本：
```bash
curl -fsSL https://raw.githubusercontent.com/liuyewen111/vps-cleaner/main/clean.sh | bash
````
或
```bash
bash <(curl -sSL https://raw.githubusercontent.com/liuyewen111/vps-cleaner/main/clean.sh)
```bash
脚本首次运行时会自动检测你的系统类型，执行相应清理命令，并自动安装快捷命令 `vpsclean`，以后你只需输入：
```bash
vpsclean
```
即可快速再次运行清理操作，无需重复下载安装。

## 功能亮点

* 支持多种主流 Linux 发行版及包管理器（apt、yum、dnf、pacman、apk）
* 自动删除无用依赖和缓存，释放大量空间
* 清理系统日志和临时文件
* 删除用户下载目录中常见安装包残留（如 `.zip`、`.tar.gz`、`.iso`）
* 清理旧内核（Debian/Ubuntu）
* 清理 snap 缓存（如存在）
* 自动安装快捷命令，方便后续使用

## 注意事项

* 脚本需要以 root 权限运行，建议使用 `sudo` 执行。
* 运行过程中会删除缓存和日志文件，请确认无重要数据存放其中。
* 脚本适合常见 Linux 服务器环境，小众发行版兼容性可能有所差异。

## 开源协议

本项目使用 MIT License 开源，你可以自由使用和修改。
