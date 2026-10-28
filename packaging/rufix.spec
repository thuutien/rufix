%global debug_package %{nil}

Name:           rufix
Version:        %{ver}
Release:        1%{?dist}
Summary:        Rufus-style USB formatter and bootable drive creator for Linux
License:        GPL-3.0-only
URL:            https://github.com/thuutien/rufix
Source0:        %{name}-%{ver}.tar.gz
BuildArch:      noarch

Requires:       python3
Requires:       python3-gobject
Requires:       gtk3
Requires:       polkit
Requires:       dosfstools
Requires:       e2fsprogs
Requires:       exfatprogs
Requires:       ntfs-3g
# mkntfs (split out of ntfs-3g on Fedora and openSUSE)
Requires:       ntfsprogs
Requires:       util-linux
Requires:       systemd
Recommends:     parted
# Provides wimlib-imagex, used to split Windows install.wim files over 4 GB.
# (Debian/Ubuntu name: wimtools.)
Recommends:     wimlib
# Extracts 7z and RAR files in "Compressed file" mode (zip/tar need nothing extra).
Recommends:     (7zip or p7zip)

%description
A Rufus-style USB formatting and bootable-drive tool for Linux, built with
Python + GTK3. Formats USB flash drives (FAT32, exFAT, NTFS, ext4, FAT16),
writes Linux ISO/IMG images in DD mode (including compressed images) and
creates UEFI-bootable Windows installation drives from Windows ISOs.

%prep
%autosetup -n %{name}-%{ver}

%build
# Nothing to compile (Python + shell).

%install
sh install.sh --prefix-root %{buildroot}

%files
%license LICENSE
/usr/bin/rufix
/usr/lib/rufix/
/usr/share/applications/rufix.desktop
/usr/share/icons/hicolor/scalable/apps/rufix.svg
/usr/share/icons/hicolor/512x512/apps/rufix.png
/usr/share/polkit-1/actions/org.rufix.helper.policy

%changelog
