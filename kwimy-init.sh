#!/usr/bin/env bash
set -euo pipefail
marker="$HOME/.cache/kwimy-nvm-node-done"
wallpaper_marker="$HOME/.cache/kwimy-matugen-wallpaper-done"
default_wallpaper="/usr/share/kwimy-hypr/backgrounds/1.jpg"
log="$HOME/.local/share/kwimy/logs/kwimy-init.log"
autostart_file="$HOME/.config/autostart/kwimy-init.desktop"
mkdir -p "$(dirname "$log")"
echo "[$(date -Iseconds)] kwimy init start" >> "$log"

if command -v systemctl >/dev/null 2>&1; then
  for svc in hypridle.service waybar.service swaync.service mpris-proxy.service; do
    echo "[$(date -Iseconds)] enabling $svc user service" >> "$log"
    if timeout -k 5s 30s systemctl --user enable --now "$svc" >>"$log" 2>&1; then
      echo "[$(date -Iseconds)] $svc enabled and started" >> "$log"
    else
      rc=$?
      echo "[$(date -Iseconds)] failed to enable/start $svc (exit=$rc)" >> "$log"
    fi
  done
else
  echo "[$(date -Iseconds)] systemctl not available; skipping user service enable" >> "$log"
fi

if [[ ! -f "$wallpaper_marker" ]]; then
  if command -v matugen >/dev/null 2>&1; then
    if [[ -f "$default_wallpaper" ]]; then
      if command -v script >/dev/null 2>&1; then
        if printf '1\n' | timeout -k 2s 45s script -qec "matugen image '$default_wallpaper' -m dark" /dev/null >>"$log" 2>&1; then
          mkdir -p "$(dirname "$wallpaper_marker")"
          touch "$wallpaper_marker"
          echo "[$(date -Iseconds)] initialized matugen theme/wallpaper with pseudo-tty selection (option 1)" >> "$log"
        else
          rc=$?
          echo "[$(date -Iseconds)] failed matugen pseudo-tty init (exit=$rc)" >> "$log"
        fi
      else
        echo "[$(date -Iseconds)] script(1) not available; trying stdin mode for matugen" >> "$log"
        if timeout -k 2s 30s matugen image "$default_wallpaper" -m dark <<<"1" >>"$log" 2>&1; then
          mkdir -p "$(dirname "$wallpaper_marker")"
          touch "$wallpaper_marker"
          echo "[$(date -Iseconds)] initialized matugen theme/wallpaper with stdin selection (option 1)" >> "$log"
        else
          rc=$?
          echo "[$(date -Iseconds)] failed matugen stdin init (exit=$rc)" >> "$log"
        fi
      fi
    else
      echo "[$(date -Iseconds)] default wallpaper not found: $default_wallpaper" >> "$log"
    fi
  else
    echo "[$(date -Iseconds)] matugen command not available; skipping wallpaper init" >> "$log"
  fi
fi

if [[ -f "$marker" ]]; then
  if [[ -f "$autostart_file" ]]; then
    echo "[$(date -Iseconds)] marker found; removing autostart" >> "$log"
    rm -f "$autostart_file"
  fi
  exit 0
fi

run_fish_logged() {
  local label="$1"
  local fish_cmd="$2"
  local tmp_output
  local rc

  tmp_output="$(mktemp)"
  if timeout -k 10s 90s fish -lc "$fish_cmd" >"$tmp_output" 2>&1; then
    rc=0
  else
    rc=$?
  fi

  while IFS= read -r line; do
    printf '%s [fish] %s\n' "$label" "$line"
  done <"$tmp_output" >> "$log"
  rm -f "$tmp_output"

  if [[ "$rc" -eq 124 ]]; then
    echo "$label command timed out after 90s" >> "$log"
  elif [[ "$rc" -eq 137 ]]; then
    echo "$label command killed after timeout grace period" >> "$log"
  fi

  return "$rc"
}

if command -v fish >/dev/null 2>&1; then
  nvm_plugin_installed=0
  for attempt in 1 2 3; do
    attempt_log="[$(date -Iseconds)] [nvm.fish attempt $attempt/3]"
    echo "$attempt_log installing nvm.fish via fisher" >> "$log"
    if run_fish_logged "$attempt_log" '
      echo "fish version: "(fish --version)
      echo "HOME: $HOME"
      set -l fisher_fn "$HOME/.config/fish/functions/fisher.fish"
      echo "fisher function file exists: "(test -f $fisher_fn; and echo yes; or echo no)
      echo "fisher function before bootstrap: "(functions -q fisher; and echo yes; or echo no)
      echo "curl command available: "(command -q curl; and echo yes; or echo no)

      if not functions -q fisher
        if test -f $fisher_fn
          source $fisher_fn
        end
      end
      echo "fisher function after sourcing file: "(functions -q fisher; and echo yes; or echo no)

      if not functions -q fisher
        if command -q curl
          if curl -fsS --connect-timeout 8 https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
            fisher install jorgebucaran/fisher
            source $fisher_fn
          else
            echo "failed to download fisher bootstrap script from GitHub" 1>&2
          end
        end
      end

      echo "fisher function before plugin install: "(functions -q fisher; and echo yes; or echo no)
      functions -q fisher; and fisher install jorgebucaran/nvm.fish
    '; then
      nvm_plugin_installed=1
      echo "[$(date -Iseconds)] nvm.fish installed (or already present)" >> "$log"
      break
    else
      rc=$?
      echo "$attempt_log install step failed (exit=$rc)" >> "$log"
    fi
    sleep 5
  done

  if [[ "$nvm_plugin_installed" -eq 1 ]]; then
    node_log="[$(date -Iseconds)] [nvm install latest]"
    echo "$node_log starting" >> "$log"
    if run_fish_logged "$node_log" '
      echo "nvm function before install latest: "(functions -q nvm; and echo yes; or echo no)
      functions -q nvm; and nvm install latest
    '; then
      mkdir -p "$(dirname "$marker")"
      touch "$marker"
      echo "[$(date -Iseconds)] node install completed" >> "$log"
    else
      rc=$?
      echo "[$(date -Iseconds)] nvm command not available or node install failed (exit=$rc)" >> "$log"
    fi
  else
    echo "[$(date -Iseconds)] failed to install nvm.fish after retries" >> "$log"
  fi

else
  echo "[$(date -Iseconds)] fish is not installed; skipping nvm.fish bootstrap" >> "$log"
fi

if [[ -f "$marker" && -f "$autostart_file" ]]; then
  echo "[$(date -Iseconds)] init complete; removing autostart" >> "$log"
  rm -f "$autostart_file"
fi
