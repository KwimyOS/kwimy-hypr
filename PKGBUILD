# Maintainer: Kwimy
pkgname=kwimy-hypr
pkgver=0.0.2
pkgrel=6
pkgdesc="Hyprland defaults and helper scripts for Kwimy"
arch=('any')
url="https://github.com/KwimyOS"
license=('MIT')
depends=('hyprland' 'jq')
source=()
sha256sums=()

prepare() {
  rm -rf "$srcdir/kwimy-hypr"
  mkdir -p "$srcdir/kwimy-hypr"

  # Copy all files from startdir to srcdir/kwimy-hypr, including hidden ones (.config)
  # but excluding pkg, src, and the PKGBUILD itself to avoid recursion.
  find "$startdir" -maxdepth 1 \
    -not -path "$startdir" \
    -not -name "src" \
    -not -name "pkg" \
    -not -name "PKGBUILD" \
    -not -name "*.pkg.tar.*" \
    -not -name ".SRCINFO" \
    -exec cp -r {} "$srcdir/kwimy-hypr/" \;
}

package() {
  # System Configs
  install -Dm644 "$srcdir/kwimy-hypr/system/hyprland.conf" "$pkgdir/usr/share/kwimy-hypr/hyprland.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/hyprpaper.conf" "$pkgdir/usr/share/kwimy-hypr/hyprpaper.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/hypridle.conf" "$pkgdir/usr/share/kwimy-hypr/hypridle.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/hyprlock.conf" "$pkgdir/usr/share/kwimy-hypr/hyprlock.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/mocha.conf" "$pkgdir/usr/share/kwimy-hypr/mocha.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/animations.conf" "$pkgdir/usr/share/kwimy-hypr/conf/animations.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/decoration.conf" "$pkgdir/usr/share/kwimy-hypr/conf/decoration.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/execs.conf" "$pkgdir/usr/share/kwimy-hypr/conf/execs.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/env.conf" "$pkgdir/usr/share/kwimy-hypr/conf/env.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/general.conf" "$pkgdir/usr/share/kwimy-hypr/conf/general.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/gestures.conf" "$pkgdir/usr/share/kwimy-hypr/conf/gestures.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/group.conf" "$pkgdir/usr/share/kwimy-hypr/conf/group.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/input.conf" "$pkgdir/usr/share/kwimy-hypr/conf/input.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/keybinds.conf" "$pkgdir/usr/share/kwimy-hypr/conf/keybinds.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/misc.conf" "$pkgdir/usr/share/kwimy-hypr/conf/misc.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/monitors.conf" "$pkgdir/usr/share/kwimy-hypr/conf/monitors.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/rules.conf" "$pkgdir/usr/share/kwimy-hypr/conf/rules.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/conf/variables.conf" "$pkgdir/usr/share/kwimy-hypr/conf/variables.conf"
  install -Dm644 "$srcdir/kwimy-hypr/system/backgrounds/1.jpg" "$pkgdir/usr/share/kwimy-hypr/backgrounds/1.jpg"
  install -Dm644 "$srcdir/kwimy-hypr/system/backgrounds/2.jpg" "$pkgdir/usr/share/kwimy-hypr/backgrounds/2.jpg"
  install -Dm644 "$srcdir/kwimy-hypr/system/avatars/1.jpg" "$pkgdir/usr/share/kwimy-hypr/avatars/1.jpg"
  install -Dm644 "$srcdir/kwimy-hypr/system/avatars/2.jpg" "$pkgdir/usr/share/kwimy-hypr/avatars/2.jpg"

  # Skeleton Configs (The "loader" for new users)
  # We copy everything from .config in the source to /etc/skel/.config
  install -d "$pkgdir/etc/skel/.config"
  cp -a "$srcdir/kwimy-hypr/.config/." "$pkgdir/etc/skel/.config/"
  install -Dm755 "$srcdir/kwimy-hypr/scripts/kwimy-lockscreen.sh" \
    "$pkgdir/etc/skel/.local/bin/kwimy-lockscreen"

  # Helper Scripts & Metadata
  install -Dm755 "$srcdir/kwimy-hypr/run.sh" "$pkgdir/usr/share/kwimy-hypr/run.sh"
  install -Dm755 "$srcdir/kwimy-hypr/kwimy-init.sh" "$pkgdir/usr/share/kwimy-hypr/kwimy-init.sh"
  install -Dm644 "$srcdir/kwimy-hypr/README.md" "$pkgdir/usr/share/kwimy-hypr/README.md"
  install -Dm644 "$srcdir/kwimy-hypr/VERSION" "$pkgdir/usr/share/kwimy-hypr/VERSION"
  install -Dm644 "$srcdir/kwimy-hypr/LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
