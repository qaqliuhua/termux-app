#!/data/data/com.mimo.shell/files/usr/bin/bash
MIMO_ROOT="/data/local/mimo"
FLAG="$HOME/.mimo_done"
if [ -f "$FLAG" ] || [ -x "$MIMO_ROOT/bin/mimo-runtime" ]; then touch "$FLAG"; exit 0; fi
echo "╔══════════════════════════════════════╗"
echo "║  MiMo Platform 安装向导             ║"
echo "║  是否安装？[Y/n]                     ║"
echo "╚══════════════════════════════════════╝"
read -r ans
case "$ans" in
[Yy]|"")
    if ! command -v su >/dev/null 2>&1; then
        echo "❌ 需要 root 权限 (未找到 su)"
        touch "$FLAG"
        exit 1
    fi
    echo "📦 使用 su 安装 MiMo Platform 到 $MIMO_ROOT ..."
    # 下载/解压/部署需要 root (写 /data/local/mimo 与 /data/local/tmp)
    su -c '
        PKG_URL="https://github.com/qaqliuhua/mimo-platform/releases/latest/download/mimo-platform.tar.gz"
        WORK=$(mktemp -d /data/local/tmp/mimo.XXXXXX)
        echo "⬇️  下载中: $PKG_URL"
        curl -L --fail --progress-bar -o "$WORK/mimo.tar.gz" "$PKG_URL" || { echo "❌ 下载失败"; rm -rf "$WORK"; exit 1; }
        mkdir -p "$WORK/inst" /data/local/mimo
        tar -xzf "$WORK/mimo.tar.gz" -C "$WORK/inst" || { echo "❌ 解压失败"; rm -rf "$WORK"; exit 1; }
        cp -a "$WORK/inst/mimo-platform/." /data/local/mimo/
        chmod -R 755 /data/local/mimo/bin/
        rm -rf "$WORK"
        echo "✅ 部署完成"
    '
    if [ $? -eq 0 ] && [ -x "$MIMO_ROOT/bin/mimo-runtime" ]; then
        touch "$FLAG"
        echo "✅ 安装完成！输入 mimo 即可使用"
    else
        echo "❌ 安装失败，请检查网络或 root 权限"
        touch "$FLAG"
    fi
    ;;
*) touch "$FLAG" ;;
esac
