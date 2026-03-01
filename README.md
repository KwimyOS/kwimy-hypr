# kwimy-hypr

Hyprland defaults and helper scripts used by Kwimy

## Build

To build and sync the package to the repository:
```bash
./kwimy-pkgs/sync-kwimy.sh -f -r kwimy-hypr
```

## Maintenance

The `PKGBUILD` is the single source of truth for versioning.
- Update `pkgver` and `pkgrel` in `PKGBUILD`.
- The build script (`sync-kwimy.sh`) automatically updates `.SRCINFO` and `VERSION`.

## Architecture

This package uses a layered configuration strategy:

- `/usr/share/kwimy-hypr/`: Contains the **System Defaults** (managed by the package).
- `/etc/skel/.config/hypr/`: Contains the **User Loader** copied to new users' homes.
- `~/.config/hypr/hyprland.conf`: The user's config which sources the system defaults.
- `~/.config/hypr/monitors.conf`: Hardware-specific monitor settings (generated once).

## Installation Helper

The `run.sh` script is used by the Kwimy installer to finalize the user setup:

```bash
./run.sh /mnt <username>
```

This script:
1. Ensures the user has a `hyprland.conf` (copying from skel if necessary).
2. Generates a default `monitors.conf` if missing.
3. Fixes file ownership for the target user.

## Customization
- Add custom rules or overrides directly to `~/.config/hypr/hyprland.conf`.
- Edit monitor settings in `~/.config/hypr/monitors.conf`.