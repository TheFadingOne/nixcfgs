{ ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;

      autocd = true;
      autosuggestion = {
        enable = true;
        strategy = [ "history" "completion" ];
      };

      defaultKeymap = "emacs";

      history = {
        append = true;
        save = 200000;
        size = 200000;
      };

      initContent = ''
        function precmd() {
                RETVAL=$?
                GITBRANCH='''
                GITINFO='''

                if type git 2> /dev/null 1> /dev/null && git rev-parse 2> /dev/null 1> /dev/null ; then
                        GITBRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)($(git rev-parse --short HEAD 2>/dev/null))"

                        if [[ -n $(git status --short) ]]; then
                                GITINFO="*"
                        fi
                fi

                if [ $RETVAL = 0 ]; then
                        RETVAL_STR=""
                else
                        RETVAL_STR="%F{red}(''${RETVAL})%f"
                fi
        }

        setprompt () {
                setopt prompt_subst

                PROMPT='$''\{RETVAL_STR}[%F{$HOSTNAME_COLOR}%n%f@%m : %(4~|.../%3~|%~) %F{red}''${GITBRANCH}%f''${GITINFO}] $ '
        }

        setprompt
      '';

      localVariables = {
        HOSTNAME_COLOR = "\${HOSTNAME_COLOR:-cyan}";
      };

      shellAliases = {
        ip = "ip --color";
        ls = "ls --color=auto";
        grep = "grep --color=auto";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
