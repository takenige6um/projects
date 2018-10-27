# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

#######################################
# 環境変数
export LANG=ja_JP.UTF-8


# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

#######################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


#######################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


#######################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

#######################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

# #######################################
# # エイリアス
#
# alias la='ls -a'
# alias ll='ls -l'
#
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# alias mkdir='mkdir -p'
#
# # sudo の後のコマンドでエイリアスを有効にする
# alias sudo='sudo '
#
# # グローバルエイリアス
# alias -g L='| less'
# alias -g G='| grep'
#
# # C で標準出力をクリップボードにコピーする
# # mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
# if which pbcopy >/dev/null 2>&1 ; then
#     # Mac
#     alias -g C='| pbcopy'
# elif which xsel >/dev/null 2>&1 ; then
#     # Linux
#     alias -g C='| xsel --input --clipboard'
# elif which putclip >/dev/null 2>&1 ; then
#     # Cygwin
#     alias -g C='| putclip'
# fi



#######################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

#  vim:set ft=zsh:



# alias E='emacsclient -t'
# alias kill-emacs="emacsclient -e '(kill-emacs)'"



# ###############################

# # http://qiita.com/kamomeZ/items/6aac2530baf42b93e336



# # UTF-8
# export LANG=ja_JP.UTF-8

# # COREを作らない
# ulimit -c 0

# # Emacs ライクな操作を有効にする（文字入力中に Ctrl-F,B でカーソル移動など）
# bindkey -e

# # autoloadされる関数を検索するパス
# fpath=(~/.zfunc $fpath)
# fpath=(~/.git_completion $fpath)
# fpath=(~/.zsh.d/anyframe(N-/) $fpath)

# # zsh plugin
# autoload -Uz anyframe-init
# anyframe-init

# # 履歴の保存先と保存数
# HISTFILE=$HOME/.zsh_history
# HISTSIZE=100000
# SAVEHIST=100000

# # 色の設定
# local DEFAULT=$'%{^[[m%}'$
# local RED=$'%{^[[1;31m%}'$
# local GREEN=$'%{^[[1;32m%}'$
# local YELLOW=$'%{^[[1;33m%}'$
# local BLUE=$'%{^[[1;34m%}'$
# local PURPLE=$'%{^[[1;35m%}'$
# local LIGHT_BLUE=$'%{^[[1;36m%}'$
# local WHITE=$'%{^[[1;37m%}'$

# export LSCOLORS=exfxcxdxbxegedabagacad
# export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# # 自動補完を有効にする
# # コマンドの引数やパス名を途中まで入力して <Tab> を押すといい感じに補完してくれる
# autoload -U compinit; compinit -u

# # 入力したコマンド名が間違っている場合には修正
# setopt correct
# setopt correct_all
# # 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# setopt auto_cd
# # cd した先のディレクトリをディレクトリスタックに追加する
# # ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# setopt auto_pushd
# # pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
# setopt pushd_ignore_dups
# # 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# # コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
# setopt hist_ignore_all_dups
# # コマンドがスペースで始まる場合、コマンド履歴に追加しない
# setopt hist_ignore_space
# # 補完キー連打で順に補完候補を自動で補完
# setopt auto_menu
# # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
# setopt extended_glob
# # Beepを鳴らさない
# setopt no_beep
# setopt no_list_beep
# # 補完候補を詰めて表示
# setopt list_packed
# # このオプションが有効な状態で、ある変数に絶対パスのディレクトリを設定すると、即座にその変数の名前が
# # ディレクトリの名前になり、すぐにプロンプトに設定している'%~'やcdコマンドの'~'での補完に反映されるようになる。
# setopt auto_name_dirs
# # 補完実行時にスラッシュが末尾に付いたとき、必要に応じてスラッシュを除去する
# setopt auto_remove_slash
# # 行の末尾がバッククォートでも無視する
# setopt sun_keyboard_hack
# # 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
# setopt list_types
# # 補完のときプロンプトの位置を変えない
# setopt always_last_prompt
# # 変数の単語分割を行う
# setopt sh_word_split
# # 履歴にタイムスタンプを追加する
# setopt extended_history
# # Ctrl-s, Ctrl-q によるフロー制御を無効にする
# setopt no_flow_control
# # 履歴を共有する
# setopt share_history
# # バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
# setopt notify

# # <Tab> でパス名の補完候補を表示したあと、
# # 続けて <Tab> を押すと候補からパス名を選択できるようになる
# # 候補を選ぶには <Tab> か Ctrl-N,B,F,P
# zstyle ':completion:*:default' menu select=1
# # キャッシュを利用する
# zstyle ':completion:*' use-cache true
# # 補完から除外するファイル
# zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
# # ファイル補完候補に色を付ける
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# # cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする
# zstyle ':completion:*:cd:*' ignore-parents parent pwd
# # 大文字小文字を区別しない
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# # 履歴
# alias his=anyframe-widget-execute-history

# # cd
# alias cdd=anyframe-widget-cdr

# # select history
# function peco-select-history() {
#     local tac
#     if which tac > /dev/null; then
#         tac="tac"
#     else
#         tac="tail -r"
#     fi
#     BUFFER=$(\history -n 1 | \
#         eval $tac | \
#         peco --query "$LBUFFER")
#     CURSOR=$#BUFFER
#     zle clear-screen
# }
# zle -N peco-select-history
# bindkey '^r' peco-select-history

# # cdr
# autoload -Uz is-at-least
# if is-at-least 4.3.11
# then
#   autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
#   add-zsh-hook chpwd chpwd_recent_dirs
#   zstyle ':chpwd:*'      recent-dirs-max 1000
#   zstyle ':chpwd:*'      recent-dirs-default yes
#   zstyle ':completion:*' recent-dirs-insert both
# fi

# # ブランチ名を表示する
# function __git_branch() {
#   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\:\1/'
# }
# alias gbn=__git_branch

# # # Emacsはbrew版をターミナルで利用する
# # alias emacs='/usr/local/Cellar/emacs/24.5/bin/emacs -nw'
# # alias gtags='/usr/local/Cellar/global/6.5.1/bin/gtags'
# # alias screen='/usr/local/Cellar/screenutf8/4.3.1/bin/screen -U'

# # 色の設定
# if [ `uname` = "FreeBSD" ]; then
#   alias ls='ls -GF'
#   alias ll='ls -alGF'
# elif [ `uname` = "Darwin" ]; then
#   alias ls='ls -GF'
#   alias ll='ls -alGF'
# else
#   alias ls='ls -F --color=auto'
#   alias ll='ls -alF --color=auto'
# fi

# # プロンプト
# setopt prompt_subst
# if [ `whoami` = "root" ]; then
#   PROMPT='[%F{red}%n@%m%F{default}]# '
# else
#   PROMPT='[%m$(gbn)]# '
# fi
# RPROMPT='[%F{green}%d%f%F{default}]'

# # スクリーン起動
# if [ "$WINDOW" = "" ] ; then
#   screen
# fi

# function preexec() {
#   if [ $TERM_PROGRAM = 'iTerm.app' ]; then
#     mycmd=(${(s: :)${1}})
#     echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):$mycmd[1]\e\\"
#   fi
# }
# function precmd() {
#   if [ $TERM_PROGRAM = 'iTerm.app' ]; then
#     echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):idle\e\\"
#   fi
# }


###########################################
# # 環境変数
# export LANG=ja_JP.UTF-8
#
#
# # 色を使用出来るようにする
# autoload -Uz colors
# colors
#
# # emacs 風キーバインドにする
# bindkey -e
#
# # ヒストリの設定
# HISTFILE=~/.zsh_history
# HISTSIZE=1000000
# SAVEHIST=1000000
#
# # プロンプト
# # 1行表示
# # PROMPT="%~ %# "
# # 2行表示
# # PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
# # %# "
# # PROMPT='[%F{magenta}%B%n%b%f@%F{blue}%U%m%u%f]# '
# # RPROMPT='[%F{green}%d%f]'
#
#
# # # プロンプト
# setopt prompt_subst
# if [ `whoami` = "root" ]; then
#   PROMPT='[%F{red}%n@%m%F{default}]# '
# else
#   PROMPT='[%m$(gbn)]# '
# fi
# RPROMPT='[%F{green}%d%f%F{default}]'
#
#
#
#
# # 単語の区切り文字を指定する
# autoload -Uz select-word-style
# select-word-style default
# # ここで指定した文字は単語区切りとみなされる
# # / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
# zstyle ':zle:*' word-chars " /=;@:{},|"
# zstyle ':zle:*' word-style unspecified
#
# ########################################
# # 補完
# # 補完機能を有効にする
# autoload -Uz compinit
# compinit -u
#
# # 補完で小文字でも大文字にマッチさせる
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#
# # ../ の後は今いるディレクトリを補完しない
# zstyle ':completion:*' ignore-parents parent pwd ..
#
# # sudo の後ろでコマンド名を補完する
# zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
#                    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
#
# # ps コマンドのプロセス名補完
# zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
#
# # 補完候補のカーソル選択を有効に
# zstyle ':completion:*:default' menu select=1
#
# ########################################
# # vcs_info
# autoload -Uz vcs_info
# autoload -Uz add-zsh-hook
#
# zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
# zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
#
# function _update_vcs_info_msg() {
#     LANG=en_US.UTF-8 vcs_info
#     RPROMPT="${vcs_info_msg_0_}"
# }
# add-zsh-hook precmd _update_vcs_info_msg
#
#
#
# ########################################
# # antigen
#
# source ~/.zsh/.zshrc.antigen
#
# ########################################
# # zmv
#
# autoload -Uz zmv
# alias zmv='noglob zmv -W'
#
# ########################################
# # オプション
# # 日本語ファイル名を表示可能にする
# setopt print_eight_bit
#
# # beep を無効にする
# setopt no_beep
#
# # フローコントロールを無効にする
# setopt no_flow_control
#
# # Ctrl+Dでzshを終了しない
# # setopt ignore_eof
#
# # '#' 以降をコメントとして扱う
# setopt interactive_comments
#
# # ディレクトリ名だけでcdする
# # setopt auto_cd
#
# # cd したら自動的にpushdする
# # setopt auto_pushd
#
# # 重複したディレクトリを追加しない
# setopt pushd_ignore_dups
#
# # 同時に起動したzshの間でヒストリを共有する
# setopt share_history
#
# # 同じコマンドをヒストリに残さない
# setopt hist_ignore_all_dups
#
# # スペースから始まるコマンド行はヒストリに残さない
# setopt hist_ignore_space
#
# # ヒストリに保存するときに余分なスペースを削除する
# setopt hist_reduce_blanks
#
# # 高機能なワイルドカード展開を使用する
# setopt extended_glob
#
# # スペルチェック
# setopt correct
#
# ########################################
# # キーバインド
#
# # ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
# bindkey '^R' history-incremental-pattern-search-backward
#
# ########################################
# # エイリアス
#
# # alias l='ls'
# # alias la='ls -a'
# # alias ll='ls -lah'
#
# # alias rm='rm -r'
# # alias cp='cp -i'
# # alias mv='mv -i'
#
# # alias mkdir='mkdir -p'
#
# # sudo の後のコマンドでエイリアスを有効にする
# # alias sudo='sudo '
#
# # grep でヒットした文字列を強調
# alias grep="grep --color"
#
# # グローバルエイリアス
# # alias -g L='| less'
# # alias -g G='| grep -v grep | grep --color -i'
#
#
# # C で標準出力をクリップボードにコピーする
# # # mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
# # if which pbcopy >/dev/null 2>&1 ; then
# #     # Mac
# #     alias -g C='| pbcopy'
# # elif which xsel >/dev/null 2>&1 ; then
# #     # Linux
# #     alias -g C='| xsel --input --clipboard'
# # elif which putclip >/dev/null 2>&1 ; then
# #     # Cygwin
# #     alias -g C='| putclip'
# # fi
#
#
#
# # Emacs 上で快適に Bash や Zsh を利用する設定
# # http://sakito.jp/emacs/emacsshell.html
#
# if [ "$EMACS" ];then
#   export TERM=Eterm-color
# fi
#
# export TERM=xterm-color
#
#
#
# ########################################
# # OS 別の設定
# case ${OSTYPE} in
#     darwin*)
#         #Mac用の設定
#         export CLICOLOR=1
#         alias ls='ls -G -F'
#         ;;
#     linux*)
#         #Linux用の設定
#         alias ls='ls -F --color=auto'
#         ;;
# esac
#
# # vim:set ft=zsh:
#
#
# #######################################
# # percol
#
# ### cdr
# autoload -Uz is-at-least
# if is-at-least 4.3.11
# then
#   autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
#   add-zsh-hook chpwd chpwd_recent_dirs
#   zstyle ':chpwd:*' recent-dirs-max 10000
#   zstyle ':chpwd:*' recent-dirs-default yes
#   zstyle ':completion:*' recent-dirs-insert both
# fi
#
# function percol-cdr () {
#     local selected_dir=$(cdr -l | awk '{ print $2 }' | percol --query "$LBUFFER")
#     if [ -n "$selected_dir" ]; then
#         BUFFER="cd ${selected_dir}"
#         zle accept-line
#     fi
#     zle clear-screen
# }
# zle -N percol-cdr
#
# bindkey '^j' percol-cdr
#
# ### search
# function exists { which $1 &> /dev/null }
#
# if exists percol; then
#     function percol_select_history() {
#         local tac
#         exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
#         BUFFER=$(history -n 1 | eval $tac | percol --query "$LBUFFER")
#         CURSOR=$#BUFFER         # move cursor
#         zle -R -c               # refresh
#     }
#
#     zle -N percol_select_history
#     bindkey '^R' percol_select_history
# fi
