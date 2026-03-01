#!/bin/bash

# Matugen passes 'dark' or 'light' as the first argument
MODE=$1

if [ "$MODE" = "dark" ]; then
    ICON_THEME="Papirus-Dark"
    GTK_THEME="adw-gtk3-dark"
else
    # Check if Papirus-Light exists, fall back to Papirus
    if [ -d "/usr/share/icons/Papirus-Light" ]; then
        ICON_THEME="Papirus-Light"
    else
        ICON_THEME="Papirus"
    fi
    GTK_THEME="adw-gtk3-light"
fi

# Live Update via GSettings
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"

# Sync Files
sync_gtk_file() {
    local file=$1
    local folder=$(dirname "$file")
    mkdir -p "$folder"

    # Create the file with a header if it's totally missing
    if [ ! -f "$file" ]; then
        echo "[Settings]" > "$file"
    fi

    # Define the settings we want to enforce. Using an associative array to map keys to values
    declare -A settings
    settings["gtk-theme-name"]="$GTK_THEME"
    settings["gtk-icon-theme-name"]="$ICON_THEME"
    settings["gtk-application-prefer-dark-theme"]="$([ "$MODE" = "dark" ] && echo 1 || echo 0)"
    settings["gtk-cursor-theme-name"]="Adwaita"
    settings["gtk-cursor-theme-size"]="24"
    settings["gtk-font-name"]="Sans 10"
    settings["gtk-menu-images"]="1"
    settings["gtk-button-images"]="1"
    settings["gtk-decoration-layout"]="menu:"

    # Loop through the settings and apply them
    for key in "${!settings[@]}"; do
        value="${settings[$key]}"
        if grep -q "^$key =" "$file"; then
            # If the line exists, update it
            sed -i "s|^$key =.*|$key = $value|" "$file"
        else
            # If the line is missing, append it to the end
            echo "$key = $value" >> "$file"
        fi
    done
}

# Apply to GTK3 and GTK4
sync_gtk_file "$HOME/.config/gtk-3.0/settings.ini"
sync_gtk_file "$HOME/.config/gtk-4.0/settings.ini"

# Special Case: GTK2 (Legacy)
GTK2_FILE="$HOME/.gtkrc-2.0"
if [ ! -f "$GTK2_FILE" ]; then
    echo -e "gtk-theme-name = \"$GTK_THEME\"\ngtk-icon-theme-name = \"$ICON_THEME\"" > "$GTK2_FILE"
else
    sed -i "s/^gtk-theme-name =.*/gtk-theme-name = \"$GTK_THEME\"/" "$GTK2_FILE"
    sed -i "s/^gtk-icon-theme-name =.*/gtk-icon-theme-name = \"$ICON_THEME\"/" "$GTK2_FILE"
fi
