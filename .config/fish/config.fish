set -gx EDITOR nvim
set -gx VISUAL nvim

fish_add_path ~/.local/bin

# NVM (Node Version Manager)
set -gx NVM_DIR $HOME/.nvm
set -g KWIMY_NVM_READY_MARKER $HOME/.cache/kwimy-nvm-node-done

function load_nvmrc --on-variable PWD
    if test -f $KWIMY_NVM_READY_MARKER; and functions -q nvm; and test -f .nvmrc
        nvm use >/dev/null 2>&1
    end
end

function sudo
    if test "$argv[1]" = "nvim"
        # Remove first argument (nvim)
        set -e argv[1]
        command sudoedit $argv
    else
        command sudo $argv
    end
end

if status is-interactive
    # Starship custom prompt
    if test -f $KWIMY_NVM_READY_MARKER; and functions -q nvm
        nvm use latest >/dev/null 2>&1
    end

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    alias ls='eza --icons --group-directories-first -1'

    # Custom colours
    # cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end
