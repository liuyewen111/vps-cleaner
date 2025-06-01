#!/bin/bash

echo "======================"
echo "VPS 一键清理脚本开始"
echo "======================"

if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 用户运行此脚本"
  exit 1
fi

# 读取 /etc/os-release，获取系统信息
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    OS_LIKE=$ID_LIKE
else
    OS=""
    OS_LIKE=""
fi

echo "检测到系统: $OS"

# 定义各类清理函数
clean_apt() {
    echo "使用 apt 清理"
    apt update -y
    apt autoremove -y
    apt clean
    dpkg -l 'linux-image-*' | grep ^ii | grep -v "$(uname -r | cut -d'-' -f1,2)" | awk '{print $2}' | xargs -r apt -y purge
}

clean_yum() {
    echo "使用 yum 清理"
    yum makecache -y
    yum autoremove -y
    yum clean all
    package-cleanup --oldkernels --count=1 -y || true
}

clean_dnf() {
    echo "使用 dnf 清理"
    dnf makecache -y
    dnf autoremove -y
    dnf clean all
    dnf remove $(dnf repoquery --installonly --latest-limit=-1 -q) -y || true
}

clean_pacman() {
    echo "使用 pacman 清理"
    pacman -Syu --noconfirm
    pacman -Sc --noconfirm
}

clean_apk() {
    echo "使用 apk 清理"
    apk update
    apk autoremove
    rm -rf /var/cache/apk/*
}

# 优先根据 /etc/os-release 的 ID 和 ID_LIKE 判断
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]] || [[ "$OS_LIKE" == *"debian"* ]]; then
    clean_apt
elif [[ "$OS" == "centos" || "$OS" == "rhel" || "$OS_LIKE" == *"rhel"* ]]; then
    clean_yum
elif [[ "$OS" == "fedora" ]]; then
    clean_dnf
elif [[ "$OS" == "alpine" ]]; then
    clean_apk
elif [[ "$OS" == "arch" ]]; then
    clean_pacman
else
    # 如果上面没匹配到，尝试检测包管理器命令，按优先级执行
    if command -v apt >/dev/null 2>&1; then
        clean_apt
    elif command -v yum >/dev/null 2>&1; then
        clean_yum
    elif command -v dnf >/dev/null 2>&1; then
        clean_dnf
    elif command -v pacman >/dev/null 2>&1; then
        clean_pacman
    elif command -v apk >/dev/null 2>&1; then
        clean_apk
    else
        echo "未识别的包管理器，无法自动清理"
    fi
fi

# 通用缓存和日志清理
echo "清理 /var/cache/ 和日志文件"
rm -rf /var/cache/apt/archives/* 2>/dev/null
rm -rf /var/cache/*
rm -rf /var/tmp/*
find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;

echo "清理 /root 和 /home 目录下载残留文件"
find /root -type f \( -name "*.zip" -o -name "*.tar.gz" -o -name "*.sh" -o -name "*.iso" \) -delete 2>/dev/null
find /home -type f \( -name "*.zip" -o -name "*.tar.gz" -o -name "*.sh" -o -name "*.iso" \) -delete 2>/dev/null

if command -v journalctl >/dev/null 2>&1; then
    echo "清理 systemd 日志"
    journalctl --vacuum-time=1d
fi

if command -v snap >/dev/null 2>&1; then
    echo "清理 snap 缓存"
    rm -rf /var/lib/snapd/cache/*
fi

echo "======================"
echo "清理完成"
echo "建议重启 VPS 查看空间释放情况"
echo "======================"

# 添加快捷命令标志文件路径
INSTALLED_FLAG=/usr/local/bin/.vpsclean_installed
REJECTED_FLAG=/usr/local/bin/.vpsclean_rejected

if [ ! -f "$INSTALLED_FLAG" ] && [ ! -f "$REJECTED_FLAG" ]; then
    read -p "是否将本脚本添加为系统命令 vpsclean？(Y/n): " confirm
    confirm=${confirm:-Y}
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        curl -sLo /usr/local/bin/vpsclean https://raw.githubusercontent.com/liuyewen111/vps-cleaner/main/clean.sh
        chmod +x /usr/local/bin/vpsclean
        touch "$INSTALLED_FLAG"
        echo "脚本已添加为系统命令：vpsclean"
        echo "以后只需输入 'vpsclean' 运行"
    else
        touch "$REJECTED_FLAG"
        echo "未添加快捷命令"
    fi
fi
