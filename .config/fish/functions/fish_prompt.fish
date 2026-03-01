function fish_prompt
    set_color cyan --bold
    echo -n "  "

    # Current directory
    set_color cyan --bold

    if test (pwd) = $HOME
        echo -n "~"
    else
        echo -n (basename (pwd))
    end

    # Git info
    if command -v git >/dev/null
        set branch (command git symbolic-ref --short HEAD 2>/dev/null)

        if test -n "$branch"
            echo -n " "

            # Git icon
            set_color blue
            echo -n " "

            # Branch name
            set_color green
            echo -n $branch

            # Dirty check
            command git diff --quiet --ignore-submodules HEAD 2>/dev/null
            set dirty $status

            set_color green
            echo -n "["

            if test $dirty -ne 0
                set_color yellow
                echo -n "⚡"
                set_color green
                            else
                # Clean repo
                set_color green
                echo -n "👀"
            end

            echo -n "]"
        end
    end

    set_color normal
    echo -n " "
end
