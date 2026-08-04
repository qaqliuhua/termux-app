#!/data/data/com.mimo.shell/files/usr/bin/bash
# MiMo Platform 安装脚本 — 首次启动时运行
MIMO_ROOT="/data/local/mimo"
FLAG_FILE="$HOME/.mimo_installed"

# 检测是否已安装
if [ -f "$FLAG_FILE" ] || [ -x "$MIMO_ROOT/bin/mimo-runtime" ]; then
    touch "$FLAG_FILE"
    exit 0
fi

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     MiMo Platform 安装向导              ║"
echo "║                                          ║"
echo "║  在 Android 上为 AI Agent 提供 Linux 运行  ║"
echo "║  环境 (glibc + MiMoCode)                 ║"
echo "║                                          ║"
echo "║  需要: Root 权限 + 约 300MB 存储         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo -n "是否安装 MiMo Platform？[Y/n] "
read -r answer
case "$answer" in
    [Yy]|"")
        echo ""
        echo "▶️ 开始安装..."
        PKG_URL="https://github.com/qaqliuhua/mimo-platform/releases/latest/download/mimo-platform.tar.gz"
        PKG_FILE="/data/local/tmp/mimo-platform.tar.gz"
        
        echo "  下载发布包..."
        curl -L --fail --progress-bar -o "$PKG_FILE" "$PKG_URL" 2>/dev/null || {
            echo "❌ 下载失败"
            exit 1
        }
        
        echo "  部署..."
        TMP_DIR="/data/local/tmp/mimo_install"
        mkdir -p "$TMP_DIR" "$MIMO_ROOT"
        tar -xzf "$PKG_FILE" -C "$TMP_DIR" 2>/dev/null
        cp -a "$TMP_DIR/mimo-platform/." "$MIMO_ROOT/" 2>/dev/null
        chmod -R 755 "$MIMO_ROOT/bin/" 2>/dev/null
        
        if [ -d "$TMP_DIR/mimo-platform/ksu-module" ] && [ -d /data/adb/modules ]; then
            echo "  安装 KSU 模块..."
            rm -rf /data/adb/modules/mimo-runtime 2>/dev/null
            cp -a "$TMP_DIR/mimo-platform/ksu-module" /data/adb/modules/mimo-runtime 2>/dev/null
        fi
        
        rm -rf "$TMP_DIR"
        mkdir -p "$MIMO_ROOT/data/mimocode/.config/mimocode" 2>/dev/null
        touch "$FLAG_FILE"
        echo ""
        echo "✅ 安装完成！重启手机后生效"
        echo "   配置 API Key: vi $MIMO_ROOT/data/mimocode/.config/mimocode/mimocode.jsonc"
        echo "   启动: mimo-runtime app start mimocode"
        ;;
    *)
        echo "跳过安装"
        touch "$FLAG_FILE"
        ;;
esac
