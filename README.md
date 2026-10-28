# Rufix

<p align="center">
  <img src="data/rufix.png" alt="Rufix official logo — bootable USB tool for Linux" width="600">
</p>

[![AUR version](https://img.shields.io/aur/version/rufix)](https://aur.archlinux.org/packages/rufix)

A Rufus-style USB formatting and bootable-drive tool for **Linux**, built
with Python + GTK3. It is not tied to any one distribution: it runs on any
modern Linux desktop, including Ubuntu, Debian, Linux Mint, Pop!_OS,
Fedora, openSUSE, Arch, Manjaro and their derivatives, under GNOME, KDE
Plasma, Cinnamon, Xfce, MATE and other desktops.

<p align="center">
  <img src="docs/screenshots/drive-iso.png" alt="Writing an ISO image" width="32%">
  <img src="docs/screenshots/compressed-file.png" alt="Extracting a compressed file to a USB drive" width="32%">
  <img src="docs/screenshots/settings.png" alt="Settings tab" width="32%">
</p>
<p align="center"><em>Bootable ISO · Compressed file extraction · Settings</em></p>

## Features

- Lists only USB flash drives and SD cards (fixed USB disks behind the
  *List USB Hard Drives* option). Internal disks and the disk running your
  system are never shown, and the root helper re-checks this.
- **Non bootable format**: FAT32, exFAT, NTFS, ext4, FAT16 · MBR or GPT ·
  volume label · cluster size · quick or full (zero-fill) format.
- **Bad blocks check** (1–4 write/read passes, like Rufus).
- **Linux ISOs / disk images** written in **DD mode** with read-back
  verification. Accepts `.iso`, `.img`, `.raw` and compressed
  `.img.xz` / `.img.gz` / `.img.bz2` (decompressed on the fly).
- **ISO mode (file copy)**: FAT32 UEFI-bootable drive from an ISO.
- **Windows 10/11 ISOs**: UEFI-bootable install drive.
  - `install.wim` > 4 GB is split automatically if `wimlib` (`wimtools` on
    Debian/Ubuntu) is installed; otherwise a FAT32 BOOT + NTFS INSTALL
    two-partition layout is used.
  - Rufus-style *Windows User Experience* options: skip TPM 2.0 / Secure
    Boot / 4GB RAM checks, skip the online Microsoft account, skip privacy
    questions (via `autounattend.xml`).
- **Compressed file**: format the drive, then extract a `.zip`, `.7z`,
  `.rar` or `.tar.*` archive onto it. Zip and tar work out of the box; 7z
  and RAR need 7-Zip (`7zip` or `p7zip-full`; `unrar` also works for RAR).
  The archive is checked before anything is erased: files over 4 GB on
  FAT32, archives too big for the drive and unsafe paths are refused.
  Extraction runs with your own user rights, not as root.
- MD5 / SHA-1 / SHA-256 checksum of the selected file (`#` button).
- Drag & drop an image onto the window; open images from the file manager.
- Progress, speed and time remaining, cancel, and a saveable log.
- **Settings tab**: remember the last used settings between runs, and check
  for and install new versions from GitHub (downloads are verified against
  their published SHA-256 checksum).

## Install

Get the files from the
[latest release](https://github.com/thuutien/rufix/releases/latest).

### One-liner (any supported distro)

```bash
curl -fsSL https://raw.githubusercontent.com/thuutien/rufix/main/packaging/quick-install.sh | sudo bash
```

This installs dependencies via `apt` / `dnf` / `pacman` / `zypper`,
downloads the release tarball and runs the installer. Variants:

```bash
curl -fsSL .../quick-install.sh | sudo bash -s -- 0.3.1      # pin a version
curl -fsSL .../quick-install.sh | sudo bash -s -- --no-deps  # skip dependency install
curl -fsSL .../quick-install.sh | sudo bash -s -- --uninstall
```

### Arch Linux (AUR)

```bash
yay -S rufix
```

Or manually: `git clone https://aur.archlinux.org/rufix.git && cd rufix && makepkg -si`.

### Flatpak (any distro)

Download `rufix-<version>-x86_64.flatpak` from the release page, then:

```bash
flatpak install --user ./rufix-0.3.1-x86_64.flatpak
flatpak run org.rufix.Rufix
```

The Flatpak bundles the interface. Formatting still uses your system's
tools (dosfstools, ntfs-3g, exfatprogs, e2fsprogs, polkit, Python 3), which
most desktops already have; the root helper runs on the host through
`pkexec`. Flatpak bundles are built automatically by GitHub Actions on every
push.

### Debian / Ubuntu / Linux Mint / Pop!_OS (.deb)

```bash
sudo apt install ./rufix_0.3.1_all.deb
```

`apt` pulls in all dependencies. For splitting large Windows images, also
install `wimtools`.

### Fedora / RHEL / openSUSE (.rpm)

```bash
sudo dnf install ./rufix-0.3.1-1.noarch.rpm        # Fedora / RHEL
sudo zypper install ./rufix-0.3.1-1.noarch.rpm     # openSUSE
```

The package manager pulls in all dependencies. For splitting large Windows
images, also install `wimlib`.

### Portable AppImage

Download `rufix-0.3.1-x86_64.AppImage`, make it executable and run it:

```bash
chmod +x rufix-0.3.1-x86_64.AppImage
./rufix-0.3.1-x86_64.AppImage
```

It bundles Rufix itself and uses your system's Python 3, GTK 3 and
formatting tools (same requirements as below). The privileged helper runs
from inside the bundle via `pkexec`, so no system-wide installation is
needed. (On older releases such as Ubuntu 20.04 / Mint 20, install
`exfat-utils` instead of `exfatprogs`.)

### Other distributions (tarball)

Download `rufix-0.3.1.tar.gz`, install the dependencies (Python 3 GObject
bindings, GTK 3, dosfstools, ntfs-3g, exfatprogs, e2fsprogs, polkit,
util-linux), then:

```bash
tar xzf rufix-0.3.1.tar.gz && cd rufix-0.3.1 && sudo ./install.sh
```

## Build the packages yourself

```bash
./packaging/build-deb.sh        # dist/rufix_<version>_all.deb
./packaging/build-tarball.sh    # dist/rufix-<version>.tar.gz
./packaging/build-rpm.sh        # dist/rufix-<version>-1.noarch.rpm (needs rpm-build)
./packaging/build-appimage.sh   # dist/rufix-<version>-x86_64.AppImage (needs appimagetool)
./packaging/build-flatpak.sh    # dist/rufix-<version>-x86_64.flatpak (needs flatpak-builder)
cd packaging/arch && makepkg -si   # Arch Linux package
```

Rufix then appears in the menu under **Administration / System Tools**.
To remove it: `sudo ./install.sh --uninstall`
(or `sudo apt remove rufix` / `sudo dnf remove rufix` / `yay -R rufix`).

## Run from source

```bash
./rufix.py
```

Requires the dependencies listed above for your distro.

## How it works

The GUI runs as your normal user. When you press START, it launches
`rufix-helper` through `pkexec` (you get the standard password prompt),
sends it the job as JSON, and the helper streams progress back. Only the
helper runs as root, and it refuses any device that is not a removable/USB
whole disk or that holds a system mount point.

## Limitations

- Bootable drives made in **ISO mode** are UEFI-only (no legacy BIOS boot
  loader is installed). For Linux ISOs, DD mode is the default and boots on
  both BIOS and UEFI.
- Windows-to-Go, persistent partitions and FreeDOS are not implemented.

## License

Rufix is free software under the GNU General Public License v3.0 only,
see [LICENSE](LICENSE).
