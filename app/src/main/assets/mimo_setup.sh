#!/data/data/com.mimo.shell/files/usr/bin/bash
MIMO_ROOT="/data/local/mimo"
FLAG="$HOME/.mimo_done"
if [ -f "$FLAG" ] || [ -x "$MIMO_ROOT/bin/mimo-runtime" ]; then touch "$FLAG"; exit 0; fi
echo "╔══════════════════════════════════════╗"
echo "║  MiMo Platform 安装向导             ║"
echo "║  是否安装？[Y/n]                     ║"
echo "╚══════════════════════════════════════╝"
read -r ans
case "$ans" in [Yy]|"")
    PKG_URL="https://github.com/qaqliuhua/mimo-platform/releases/latest/download/mimo-platform.tar.gz"
    curl -L --fail --progress-bar -o /data/local/tmp/mimo.tar.gz "$PKG_URL"
    mkdir -p /data/local/tmp/mimo_inst "$MIMO_ROOT"
    tar -xzf /data/local/tmp/mimo.tar.gz -C /data/local/tmp/mimo_inst
    cp -a /data/local/tmp/mimo_inst/mimo-platform/. "$MIMO_ROOT/"
    chmod -R 755 "$MIMO_ROOT/bin/"
    rm -rf /data/local/tmp/mimo_inst /data/local/tmp/mimo.tar.gz
    touch "$FLAG"
    echo "✅ 安装完成！重启手机生效"
    ;; *) touch "$FLAG" ;;
esac
