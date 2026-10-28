#!/bin/sh
# Install (or uninstall with --uninstall) Rufix system-wide.
# Usage: sudo ./install.sh [--uninstall] [--prefix-root DIR]
set -e

ROOT=""
UNINSTALL=0
while [ $# -gt 0 ]; do
    case "$1" in
        --uninstall) UNINSTALL=1 ;;
        --prefix-root) ROOT="$2"; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

LIB="$ROOT/usr/lib/rufix"
BIN="$ROOT/usr/bin/rufix"
DESKTOP="$ROOT/usr/share/applications/rufix.desktop"
ICON_SVG="$ROOT/usr/share/icons/hicolor/scalable/apps/rufix.svg"
ICON_PNG="$ROOT/usr/share/icons/hicolor/512x512/apps/rufix.png"
POLICY="$ROOT/usr/share/polkit-1/actions/org.rufix.helper.policy"

if [ "$UNINSTALL" = 1 ]; then
    rm -rf "$LIB" "$BIN" "$DESKTOP" "$ICON_SVG" "$ICON_PNG" "$POLICY"
    echo "Rufix uninstalled."
    exit 0
fi

if [ -z "$ROOT" ] && [ "$(id -u)" != 0 ]; then
    echo "Please run as root: sudo $0"
    exit 1
fi

SRC="$(cd "$(dirname "$0")" && pwd)"

install -d "$LIB/rufix"
install -m 644 "$SRC"/rufix/__init__.py "$SRC"/rufix/app.py "$SRC"/rufix/devices.py \
    "$SRC"/rufix/imageinfo.py "$SRC"/rufix/helper.py "$SRC"/rufix/updater.py "$LIB/rufix/"
# The helper is what pkexec runs; its path must match the polkit policy.
sed '1s|.*|#!/usr/bin/python3|' "$SRC/rufix/helper.py" > "$LIB/rufix-helper"
chmod 755 "$LIB/rufix-helper"
install -D -m 755 "$SRC/data/rufix-launcher" "$BIN"
install -D -m 644 "$SRC/data/rufix.desktop" "$DESKTOP"
install -D -m 644 "$SRC/data/rufix.svg" "$ICON_SVG"
install -D -m 644 "$SRC/data/rufix.png" "$ICON_PNG"
install -D -m 644 "$SRC/data/org.rufix.helper.policy" "$POLICY"

if [ -z "$ROOT" ]; then
    command -v gtk-update-icon-cache >/dev/null && gtk-update-icon-cache -q -t /usr/share/icons/hicolor || true
    command -v update-desktop-database >/dev/null && update-desktop-database -q /usr/share/applications || true
    echo "Rufix installed. Launch it from the menu (System Tools > Rufix) or run: rufix"
fi
