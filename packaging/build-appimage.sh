#!/bin/sh
# Build a portable AppImage (bundles Rufix itself; uses the host's
# python3 + GTK 3 and system formatting tools, like the tarball install).
# The privileged helper runs from inside the bundle via pkexec, so no
# system-wide installation is needed.
# Usage: ./packaging/build-appimage.sh   ->   dist/rufix-<version>-x86_64.AppImage
set -e
SRC="$(cd "$(dirname "$0")/.." && pwd)"
VERSION=$(sed -n 's/^__version__ = "\(.*\)"/\1/p' "$SRC/rufix/__init__.py")
ARCH="${ARCH:-x86_64}"

WORK="$SRC/dist/AppDir"
rm -rf "$WORK"
mkdir -p "$WORK/usr/share/rufix" "$WORK/usr/bin"
cp "$SRC/rufix.py" "$WORK/usr/share/rufix/"
cp -r "$SRC/rufix" "$WORK/usr/share/rufix/"
find "$WORK" -name '__pycache__' -type d -prune -exec rm -rf {} +
find "$WORK" -name '*.pyc' -delete
cp "$SRC/data/rufix.desktop" "$WORK/rufix.desktop"
cp "$SRC/data/rufix.svg" "$WORK/rufix.svg"
cp "$SRC/data/rufix.png" "$WORK/rufix.png"
cp "$SRC/data/rufix.png" "$WORK/.DirIcon"
cat > "$WORK/AppRun" <<'APPRUN'
#!/bin/sh
APPDIR="$(dirname "$(readlink -f "$0")")"
exec /usr/bin/python3 "$APPDIR/usr/share/rufix/rufix.py" "$@"
APPRUN
chmod +x "$WORK/AppRun"

if command -v appimagetool >/dev/null; then
    APPIMAGETOOL="appimagetool"
else
    TOOL="$SRC/dist/appimagetool-$ARCH.AppImage"
    if [ ! -x "$TOOL" ]; then
        echo "Downloading appimagetool..."
        curl -fsSL -o "$TOOL" \
            "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-$ARCH.AppImage"
        chmod +x "$TOOL"
    fi
    APPIMAGETOOL="$TOOL"
fi

ARCH="$ARCH" "$APPIMAGETOOL" "$WORK" "$SRC/dist/rufix-$VERSION-$ARCH.AppImage"
ls "$SRC/dist"/*.AppImage
