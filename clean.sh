#!/bin/bash

echo "======================"
echo "VPS 一键清理脚本开始"
echo "======================"

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 用户运行此脚本"
  exit 1
fi

# 更新软件包信息
echo "正在更新软件包信息..."
apt update -y

# 自动删除不再需要的依赖包
echo "正在自动删除无用依赖包（autoremove）..."
apt autoremove -y

# 自动清理已下载的包缓存
echo "正在清理包缓存（apt clean）..."
apt clean

# 清理本地缓存和日志文件
echo "正在清理 /var/cache/ 与日志文件..."
rm -rf /var/cache/apt/archives/*
rm -rf /var/cache/*
rm -rf /var/tmp/*
find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;

# 清理用户下载目录中遗留的大文件（如安装包）
echo "正在清理 /root 和 /home 目录下的下载残留..."
find /root -type f \( -name "*.zip" -o -name "*.tar.gz" -o -name "*.sh" -o -name "*.iso" \) -delete
find /home -type f \( -name "*.zip" -o -name "*.tar.gz" -o -name "*.sh" -o -name "*.iso" \) -delete

# 清理旧内核（仅限 Debian/Ubuntu 且有多个内核时）
echo "正在尝试清理旧内核..."
dpkg -l 'linux-image-*' | grep ^ii | grep -v "$(uname -r | cut -d'-' -f1,2)" | awk '{print $2}' | xargs apt -y purge

# 清理 journald 日志
echo "正在清理 systemd 日志..."
journalctl --vacuum-time=1d

# 清理 snap 缓存（如果安装了 snap）
if command -v snap &>/dev/null; then
  echo "正在清理 snap 缓存..."
  rm -rf /var/lib/snapd/cache/*
fi

echo "======================"
echo "清理完成"
echo "建议重启 VPS 查看空间释放情况"
echo "======================"

# 添加快捷命令功能
read -p "是否将本脚本添加为系统命令 vpsclean？(Y/n): " confirm
confirm=${confirm:-Y}

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    curl -sLo /usr/local/bin/vpsclean https://raw.githubusercontent.com/liuyewen111/vps-cleaner/main/clean.sh
    chmod +x /usr/local/bin/vpsclean
    echo "脚本已添加为系统命令：vpsclean"
    echo "你以后只需要输入 'vpsclean' 即可再次运行"
else
    echo "未添加快捷命令"
fi
