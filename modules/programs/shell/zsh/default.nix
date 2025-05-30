{ pkgs
, ...
}: {
  home-manager.sharedModules = [
    (_: {
      home.file = {
        ".config/zsh/templates" = {
          source = ./templates;
          recursive = true;
        };
        ".config/zsh/scripts" = {
          source = ./scripts;
          recursive = true;
        };
      };
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        history.size = 100000;
        history.path = "\${XDG_DATA_HOME}/zsh/history";
        dotDir = ".config/zsh";
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "gitignore" "aliases" "z" ];
        };
        initExtra = ''

          # Direnv hook
          eval "$(direnv hook zsh)"

          # Key Bindings
          bindkey -s ^l "lf\n"
          bindkey "\eOA" up-line-or-history
          bindkey "\eOB" down-line-or-history

          # options
          unsetopt menu_complete
          unsetopt flowcontrol

          setopt prompt_subst
          setopt always_to_end
          setopt append_history
          setopt auto_menu
          setopt complete_in_word
          setopt extended_history
          setopt hist_expire_dups_first
          setopt hist_ignore_dups
          setopt hist_ignore_space
          setopt hist_verify
          setopt inc_append_history
          setopt share_history

          function lf {
              tmp="$(mktemp)"
              # `command` is needed in case `lfcd` is aliased to `lf`
              command lf -last-dir-path="$tmp" "$@"
              if [ -f "$tmp" ]; then
                  dir="$(cat "$tmp")"
                  rm -f "$tmp"
                  if [ -d "$dir" ]; then
                      if [ "$dir" != "$(pwd)" ]; then
                          cd "$dir"
                      fi
                  fi
              fi
          }
          function ex {
           if [ -z "$1" ]; then
              # display usage if no parameters given
              echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
              echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
           else
              for n in "$@"
              do
                if [ -f "$n" ] ; then
                    case "''${n%,}" in
                      *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                      ${pkgs.gnutar}/bin/tar xvf "$n"       ;;
                      *.lzma)      unlzma ./"$n"      ;;
                      *.bz2)       bunzip2 ./"$n"     ;;
                      *.cbr|*.rar)       unrar x -ad ./"$n" ;;
                      *.gz)        gunzip ./"$n"      ;;
                      *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
                      *.z)         uncompress ./"$n"  ;;
                      *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                      ${pkgs.p7zip}/bin/7z x ./"$n"        ;;
                      *.xz)        unxz ./"$n"        ;;
                      *.exe)       cabextract ./"$n"  ;;
                      *.cpio)      cpio -id < ./"$n"  ;;
                      *.cba|*.ace)      unace x ./"$n"      ;;
                      *)
                      echo "Unsupported format"
                      return 1
                      ;;
                    esac
                else
                    echo "'$n' - file does not exist"
                    return 1
                fi
              done
           fi
          }
          function cgen {
            if [ -d "$1" ]; then
              echo "Directory \"$1\" already exists!"
              return 1
            fi
            mkdir $1 && cd $1
            cat ~/.config/zsh/templates/ListTemplate.txt >> CMakeLists.txt
            mkdir src
            mkdir include
            cat ~/.config/zsh/templates/HelloWorldTemplate.txt >> src/main.cpp
            cat ~/.config/zsh/templates/shell.txt >> shell.nix
            cat ~/.config/zsh/templates/envrc-nix.txt >> .envrc
            direnv allow
            #echo "Created the following Directories and files."
            ${pkgs.eza}/bin/eza --icons=auto --tree .
          }

        '';
        envExtra = ''
                # Defaults
          export XMONAD_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/xmonad" # xmonad.hs is expected to stay here
          export XMONAD_DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"
          export XMONAD_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"

          export STARSHIP_CONFIG=~/.config/starship/starship.toml

          export FZF_DEFAULT_OPTS=" \
          --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
          --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
          --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

          if [ -z "$XDG_CONFIG_HOME" ] ; then
              export XDG_CONFIG_HOME="$HOME/.config"
          fi
          if [ -z "$XDG_DATA_HOME" ] ; then
              export XDG_DATA_HOME="$HOME/.local/share"
          fi
          if [ -z "$XDG_CACHE_HOME" ] ; then
              export XDG_CACHE_HOME="$HOME/.cache"
          fi

          # path+=("$HOME/.local/bin")
          # export PATH="$PATH:''${$(find $HOME/.local/bin -maxdepth 1 -type d -printf %p:)%%:}"

          ### PATH
          if [ -d "$HOME/.bin" ] ;
            then PATH="$HOME/.bin:$PATH"
          fi

          if [ -d "$HOME/.local/bin" ] ;
            then PATH="$HOME/.local/bin:$PATH"
          fi

          if [ -d "$HOME/.emacs.d/bin" ] ;
            then PATH="$HOME/.emacs.d/bin:$PATH"
          fi

          if [ -d "$HOME/Applications" ] ;
            then PATH="$HOME/Applications:$PATH"
          fi

          if [ -d "/var/lib/flatpak/exports/bin/" ] ;
            then PATH="/var/lib/flatpak/exports/bin/:$PATH"
          fi

          if [ -d "$HOME/.config/emacs/bin/" ] ;
            then PATH="$HOME/.config/emacs/bin/:$PATH"
          fi

        '';
        shellGlobalAliases = {
          UUID = "$(uuidgen | tr -d \\n)";
        };
        shellAliases = {
          cls = "clear";
          cp = "cp -iv";
          mv = "mv -iv";
          rm = "rm -vi";
          mkdir = "mkdir -pv";
          grep = "grep --color=always";
          # Nixos
          list-gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system/";
          find-store-path = ''function { nix-shell -p $1 --command "nix eval -f "<nixpkgs>" --raw $1" }'';
          update-input = "nix flake lock --update-input $@";
          rebuild = "~/NixOS/install.sh --rebuild";
          # INFO: the temporary solution lmao
          nvim = "~/work/nixvim/result/bin/nvim";
          open = "~/.config/zsh/scripts/open.sh";
          cs = "~/work/Epitech/coding-style.sh . . && cat coding-style-reports.log && rm -f coding-style-reports.log";
          gs = "git status";
          copy = "wl-copy";
          paste = "wl-paste";
        };
      };
    })
  ];
}
