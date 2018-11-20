;; WEB+DB PRESS plusシリーズ
;; Emacs実践入門―思考を直感的にコード化し、開発を加速する
;; サンプルinit.el

;;; 注意事項 - まずはこちらをお読みください

;; このサンプルコードは、書籍『Emacs実践入門』に登場する設定
;; コードをまとめたものです。一部の設定では、拡張機能のインス
;; トールが必須となっているため、このファイルに書かれている内
;; 容の一部はそのまま利用することはできません。
;; 本書を読み進めながら、必要な設定をあなたのinit.elへコピー
;; してご利用ください。
;; なお、拡張機能のインストールが必要な設定については、下記の
;; ような目印を付けております。
;; 拡張機能のインストール方法については、該当ページに詳しく記
;; 述していますので、ぜひ参考にしてください。


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; カレントバッファを全て評価                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-x eval-buffer RET
;; M-x eval-region RET ;リージョン選択範囲を評価

;; C-c , ,   hownメモ

;; C-c m     multi-turm

;; M-x load-theme return ir-black


;; ▼要拡張機能インストール▼


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3.2 Emacsの起動と終了                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; P30 デバッグモードでの起動
;; おまじない
(require 'cl)
;;Emacsからの質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)
;;スタートアップメッセージを非表示
(setq inhibit-startup-screen t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4.1 効率的な設定ファイルの作り方と管理方法                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P60-61 Elisp配置用のディレクトリを作成
;; Emacs 23より前のバージョンを利用している方は
;; user-emacs-directory変数が未定義のため次の設定を追加
;;(when (< emacs-major-version 23)
;;  (defvar user-emacs-directory "~/.emacs.d/"))

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")



;;;P63 init-loader.elを利用する

;; http://coderepos.org/share/browser/lang/elisp/init-loader/init-loader.el
(require 'init-loader)
(init-loader-load "~/.emacs.d/conf") ; 設定ファイルがあるディレクトリを指定


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4.2 環境に応じた設定の分岐                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P65 CUIとGUIによる分岐
;; ターミナル以外はツールバー、スクロールバーを非表示
;; (when window-system
;;   ;; tool-barを非表示
;;   (tool-bar-mode 0)
;;   ;; scroll-barを非表示
;;   (scroll-bar-mode 0))

;; ;; CocoaEmacs以外はメニューバーを非表示
;; (unless (eq window-system 'ns)
;;  ;; menu-barを非表示
;;   (menu-bar-mode 0))

(tool-bar-mode 0)
(scroll-bar-mode 0)
;; (menu-bar-mode -1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.2 キーバインドの設定                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P80 C-hをバックスペースにする
;; 入力されるキーシーケンスを置き換える
;; ?\C-?はDELのキーシケンス
(keyboard-translate ?\C-h ?\C-?)
;; 別のキーバイドにヘルプを割り当てる
(define-key global-map (kbd "C-x ?") 'help-command)

;;; P79-81 お勧めのキー操作
;; C-mにnewline-and-indentを割り当てる。
;; 先ほどとは異なりglobal-set-keyを利用
(global-set-key (kbd "C-m") 'newline-and-indent)
;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)
;; "C-t" でウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)
;; バッファメニューは別ウインドウで
(global-set-key "\C-x\C-b" 'buffer-menu-other-window)
;; ¥の代わりにバックスラッシュを入力する
;; (define-key global-map [?¥] [?\\])
;; 165が¥（円マーク） , 92が\（バックスラッシュ）を表す
(define-key global-map [165] [92])



;; 行コピー、行キル
(defun copy-whole-line (&optional arg)
  "Copy current line."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (unless (eq last-command 'copy-region-as-kill)
    (kill-new "")
    (setq last-command 'copy-region-as-kill))
  (cond ((zerop arg)
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))))
        ((< arg 0)
         (save-excursion
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line (1+ arg))
                                       (unless (bobp) (backward-char))
                                       (point)))))
        (t
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line arg) (point))))))
  (message (substring (car kill-ring-yank-pointer) 0 -1)))


;; 行コピーを M-k に割り当てる。
(global-set-key (kbd "M-k") 'copy-whole-line)
(global-set-key (kbd "M-K") 'kill-whole-line)



;; 単語選択 M-@

(when window-system
  (defun mark-word-at-point ()
    (interactive)
    (let ((char (char-to-string (char-after (point)))))
      (cond
       ((string= " " char) (delete-horizontal-space))
       ((string-match "[\t\n -@\[-`{-~]" char) (mark-word ))
       (t (forward-char) (backward-word) (mark-word 1))))))
(when window-system
  (global-set-key "\M-@" 'mark-word-at-point))



;; 行や範囲のコピー＆ペースト

(when window-system
  (require 'duplicate-thing)
  (global-set-key (kbd "M-c") 'duplicate-thing))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.3 環境変数の設定                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P82-83 パスの設定
(when window-system
  (add-to-list 'exec-path "/opt/local/bin")
  (add-to-list 'exec-path "/usr/local/bin")
  (add-to-list 'exec-path "~/bin"))

;;; P85 文字コードを指定する
(when window-system
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8))

;;; P86 ファイル名の扱い
;; Mac OS Xの場合のファイル名の設定
;; (when (eq system-type 'darwin)
;;   (require 'ucs-normalize)
;;   (set-file-name-coding-system 'utf-8-hfs)
;;   (setq locale-coding-system 'utf-8-hfs))

;; Windowsの場合のファイル名の設定
;; (when (eq window-system 'w32)
;;   (set-file-name-coding-system 'cp932)
;;   (setq locale-coding-system 'cp932))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 利用する Shell の設定                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; より下に記述した物が PATH の先頭に追加されます
(when window-system
  (dolist (dir (list
		"/sbin"
		"/usr/sbin"
		"/bin"
		"/usr/bin"
		"/opt/local/bin"
		"/sw/bin"
		"/usr/local/bin"
		(expand-file-name "~/bin")
		(expand-file-name "~/.emacs.d/bin")
		))
    ;; PATH と exec-path に同じ物を追加します
    (when (and (file-exists-p dir) (not (member dir exec-path)))
      (setenv "PATH" (concat dir ":" (getenv "PATH")))
      (setq exec-path (append (list dir) exec-path)))))
;; MANPATH も設定しておく
(when window-system
  (setenv "MANPATH" (concat "/usr/local/man:/usr/share/man:/Developer/usr/share/man:/sw/share/man" (getenv "MANPATH"))))

;; shell の存在を確認
(when window-system
  (defun skt:shell ()
    (or (executable-find "zsh")
	(executable-find "bash")
	;; (executable-find "f_zsh") ;; Emacs + Cygwin を利用する人は Zsh の代りにこれにしてください
	;; (executable-find "f_bash") ;; Emacs + Cygwin を利用する人は Bash の代りにこれにしてください
	(executable-find "cmdproxy")
	(error "can't find 'shell' command in PATH!!"))))

;; Shell 名の設定
(when window-system
  (setq shell-file-name (skt:shell))
  (setenv "SHELL" shell-file-name)
  (setq explicit-shell-file-name shell-file-name)

  (set-language-environment  'utf-8)
  (prefer-coding-system 'utf-8))


;; (cond
;;  ((or (eq window-system 'mac) (eq window-system 'ns))
;;   ;; Mac OS X の HFS+ ファイルフォーマットではファイル名は NFD (の様な物)で扱うため以下の設定をする必要がある
;;   (require 'ucs-normalize)
;;   (setq file-name-coding-system 'utf-8-hfs)
;;   (setq locale-coding-system 'utf-8-hfs))
;;  (or (eq system-type 'cygwin) (eq system-type 'windows-nt)
;;   (setq file-name-coding-system 'utf-8)
;;   (setq locale-coding-system 'utf-8)
;;   ;; もしコマンドプロンプトを利用するなら sjis にする
;;   ;; (setq file-name-coding-system 'sjis)
;;   ;; (setq locale-coding-system 'sjis)
;;   ;; 古い Cygwin だと EUC-JP にする
;;   ;; (setq file-name-coding-system 'euc-jp)
;;   ;; (setq locale-coding-system 'euc-jp)
;;   )
;;  (t
;;   (setq file-name-coding-system 'utf-8)
;;   (setq locale-coding-system 'utf-8)))


;; Emacs が保持する terminfo を利用する
;; (setq system-uses-terminfo nil)

;; ;; エスケープを綺麗に表示する
;; (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; ;; term 呼び出しキーの割り当て
;; (global-set-key (kbd "C-c t") '(lambda ()
;;                                 (interactive)
;;                                 (term shell-file-name)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.4 フレームに関する設定                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P87-89 モードラインに関する設定
;; カラム番号も表示
(when window-system
  (column-number-mode t)
  ;; ファイルサイズを表示
  (size-indication-mode t)
  ;; ;; 時計を表示（好みに応じてフォーマットを変更可能）
  ;;  (setq display-time-day-and-date t) ; 曜日・月・日を表示
  ;;  (setq display-time-24hr-format t) ; 24時表示
  ;; (display-time-mode t)
  ;; ;; バッテリー残量を表示
  ;; (display-battery-mode t)
  ;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
  ;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
  (defun count-lines-and-chars ()
    (if mark-active
	(format "%d lines,%d chars "
		(count-lines (region-beginning) (region-end))
		(- (region-end) (region-beginning)))
      ;; これだとエコーエリアがチラつく
      ;;(count-lines-region (region-beginning) (region-end))
      ""))

  (add-to-list 'default-mode-line-format
	       '(:eval (count-lines-and-chars)))

;;; P90 タイトルバーにファイルのフルパスを表示
  (setq frame-title-format "%f"))

;; 行番号を常に表示する
;; (global-linum-mode t)

;; フリンジに行番号表示
;;(global-linum-mode nil)
;;(set-face-attribute 'linum nil :height 0.8)
;;(setq linum-format "%4d")


;; 透明度

;; ;; Color
;; (if window-system (progn
;;     (set-background-color "Black")
;;     (set-foreground-color "LightGray")
;;     (set-cursor-color "Gray")
;;     (set-frame-parameter nil 'alpha 70) ;透明度
;;     ))


;; 透明度を変更するコマンド M-x set-alpha
;; http://qiita.com/marcy@github/items/ba0d018a03381a964f24
(when window-system
  (defun set-alpha (alpha-num)
    "set frame parameter 'alpha"
    (interactive "nAlpha: ")
    ;; (set-frame-parameter nil 'alpha (cons alpha-num '(90)))))
    (set-frame-parameter nil 'alpha 65)))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.5インデントの設定                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P92-94 タブ文字の表示幅
(when window-system
	;; TABの表示幅。初期値は8
	(setq-default tab-width 2)
	;; インデントにタブ文字を使用しない
	(setq-default indent-tabs-mode nil)
	;; php-modeのみタブを利用しない
	;; (add-hook 'php-mode-hook
	;;           '(lambda ()
	;;             (setq indent-tabs-mode nil)))

	;; C、C++、JAVA、PHPなどのインデント
	(add-hook 'c-mode-common-hook
						'(lambda ()
							 (c-set-style "bsd"))))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;    web-mode                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq auto-mode-alist
      (append '(
                ("\\.\\(html\\|xhtml\\|shtml\\|tpl\\)\\'" . web-mode)
                ("\\.php\\'" . php-mode)
                )
              auto-mode-alist))

;;==========================================
;;         web-modeの設定
;;==========================================
(require 'web-mode)
(defun web-mode-hook ()
  "Hooks for Web mode."
  ;; 変更日時の自動修正
  (setq time-stamp-line-limit -200)
  (if (not (memq 'time-stamp write-file-hooks))
      (setq write-file-hooks
            (cons 'time-stamp write-file-hooks)))
  (setq time-stamp-format " %3a %3b %02d %02H:%02M:%02S %:y %Z")
  (setq time-stamp-start "Last modified:")
  (setq time-stamp-end "$")
  ;; web-modeの設定
  (setq web-mode-markup-indent-offset 0) ;; html indent
  (setq web-mode-css-indent-offset 2)    ;; css indent
  (setq web-mode-code-indent-offset 2)   ;; script indent(js,php,etc..)
  ;; htmlの内容をインデント
  ;; TEXTAREA等の中身をインデントすると副作用が起こったりするので
  ;; デフォルトではインデントしない
  ;;(setq web-mode-indent-style 2)
  ;; コメントのスタイル
  ;;   1:htmlのコメントスタイル(default)
  ;;   2:テンプレートエンジンのコメントスタイル
  ;;      (Ex. {# django comment #},{* smarty comment *},{{-- blade comment --}})
  (setq web-mode-comment-style 2)
  ;; 終了タグの自動補完をしない
  ;;(setq web-mode-disable-auto-pairing t)
  ;; color:#ff0000;等とした場合に指定した色をbgに表示しない
  ;;(setq web-mode-disable-css-colorization t)
  ;;css,js,php,etc..の範囲をbg色で表示
  ;; (setq web-mode-enable-block-faces t)
  ;; (custom-set-faces
  ;;  '(web-mode-server-face
  ;;    ((t (:background "grey"))))                  ; template Blockの背景色
  ;;  '(web-mode-css-face
  ;;    ((t (:background "grey18"))))                ; CSS Blockの背景色
  ;;  '(web-mode-javascript-face
  ;;    ((t (:background "grey36"))))                ; javascript Blockの背景色
  ;;  )
  ;;(setq web-mode-enable-heredoc-fontification t)
)
;; (add-hook 'web-mode-hook  'web-mode-hook)
;; 色の設定
;; (custom-set-faces
;;  '(web-mode-doctype-face
;;    ((t (:foreground "#82AE46"))))                          ; doctype
;;  '(web-mode-html-tag-face
;;    ((t (:foreground "#E6B422" :weight bold))))             ; 要素名
;;  '(web-mode-html-attr-name-face
;;    ((t (:foreground "#C97586"))))                          ; 属性名など
;;  '(web-mode-html-attr-value-face
;;    ((t (:foreground "#82AE46"))))                          ; 属性値
;;  '(web-mode-comment-face
;;    ((t (:foreground "#D9333F"))))                          ; コメント
;;  '(web-mode-server-comment-face
;;    ((t (:foreground "#D9333F"))))                          ; コメント
;;  '(web-mode-css-rule-face
;;    ((t (:foreground "#A0D8EF"))))                          ; cssのタグ
;;  '(web-mode-css-pseudo-class-face
;;    ((t (:foreground "#FF7F00"))))                          ; css 疑似クラス
;;  '(web-mode-css-at-rule-face
;;    ((t (:foreground "#FF7F00"))))                          ; cssのタグ
;; )


;; 主なキーアサイン
;; 個人的には、C-c C-fでタグブロックを開閉できるので、複雑なHTMLを編集するときは便利だと思う。

;; Generalなキーアサイン
;; キー	機能
;; C-c C-;	コメント/アンコメント
;; C-c C-e	閉じていないタグを見つける
;; C-c C-f	指定したタグのブロックを開閉する
;; C-c C-i	現在開いているバッファをインデントする
;; C-c C-m	マークする(マークする場所によって選択範囲が変わります)
;; C-c C-n	開始・終了タグまでジャンプ
;; C-c C-r	HTML entitiesをリプレースする
;; C-c C-s	スニペットを挿入
;; C-c C-w	スペースを表示・非表示
;; HTML element系のキーアサイン
;; キー	機能
;; C-c /	閉じタグを挿入(エレメントを閉じる)
;; C-c eb	エレメントの最初へ移動
;; C-c ed	エレメントを削除
;; C-c ee	エレメントの最後へ移動
;; C-c ee	エレメントを複製
;; C-c en	次のエレメントへ移動
;; C-c ep	前のエレメントへ移動
;; C-c eu	親エレメントへ移動
;; C-c er	エレメントをリネーム
;; C-c es	エレメント全体を選択
;; C-c ei	エレメントのコンテンツを選択
;; HTML tag系のキーアサイン
;; キー	機能
;; C-c tb	タグの先頭へ移動(エレメントの先頭では無くタグの先頭です。
;; </div>で実行した場合は</div>タグの先頭(<)に移動します)
;; C-c te	タグの後尾へ移動
;; C-c tm	マッチするタグへ移動
;; C-c ts	タグを選択
;; C-c tp	前のタグに移動
;; C-c tn	次のタグに移動






;; (require 'web-mode)

;; ;;; emacs 23以下の互換
;; (when (< emacs-major-version 24)
;;   (defalias 'prog-mode 'fundamental-mode))

;; ;;; 適用する拡張子
;; (add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;; ;;; インデント数
;; (defun web-mode-hook ()
;;   "Hooks for Web mode."
;;   (setq web-mode-html-offset   2)
;;   (setq web-mode-css-offset    2)
;;   (setq web-mode-script-offset 2)
;;   (setq web-mode-php-offset    2)
;;   (setq web-mode-java-offset   2)
;;   (setq web-mode-asp-offset    2))
;; (add-hook 'web-mode-hook 'web-mode-hook)


 (defun web-mode-indent (num)
      (interactive "nIndent: ")
      (setq web-mode-markup-indent-offset num)
      (setq web-mode-css-indent-offset num)
      (setq web-mode-style-padding num)
      (setq web-mode-code-indent-offset num)
      (setq web-mode-script-padding num)
      (setq web-mode-block-padding num)
      )
    (web-mode-indent 2)
;; 切り替える時は M-x web-mode-indent してミニバッファでインデント数を入力する。



;; 良いなと思った機能
;; web-mode-toggle-folding "C-c C-f"
;; HTMLタグを折り畳む機能です。カーソルの位置のタグ内が省略されアンダーラインでマークされます。戻すときも"C-c C-f"です。
;; web-mode-rename-element "C-c C-r"
;; タグの開始タグと終了タグの名前を変えてくれます。
;; web-mode-match-tag "C-c C-n"
;; タグの開始タグと終了タグにカーソルを持っていってくれます。入れ子しすぎて対応関係にあるタグが分からなくなった場合に便利すぎます。これで終了タグにコメントを付けずとも大丈夫ですね。
;; web-mode-delete-element "C-c C-b"
;; 現在位置のタグを丸ごと消せます。
;; web-mode-duplicate-element "C-c C-j"
;; 現在位置のタグを複製します。




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 辞書  google-translate                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; (require 'google-translate)
;; (require 'google-translate-default-ui)

;; (defvar google-translate-english-chars "[:ascii:]"
;;   "これらの文字が含まれているときは英語とみなす")
;; (defun google-translate-enja-or-jaen (&optional string)
;;   "regionか現在位置の単語を翻訳する。C-u付きでquery指定も可能"
;;   (interactive)
;;   (setq string
;;         (cond ((stringp string) string)
;;               (current-prefix-arg
;;                (read-string "Google Translate: "))
;;               ((use-region-p)
;;                (buffer-substring (region-beginning) (region-end)))
;;               (t
;;                (thing-at-point 'word))))
;;   (let* ((asciip (string-match
;;                   (format "\\`[%s]+\\'" google-translate-english-chars)
;;                   string)))
;;     (run-at-time 0.1 nil 'deactivate-mark)
;;     (google-translate-translate
;;      (if asciip "en" "ja")
;;      (if asciip "ja" "en")
;;      string)))

;; ;; (push '("\*Google Translate\*" :height 0.5 :stick t) popwin:special-display-config)

;; (global-set-key (kbd "C-M-t") 'google-translate-enja-or-jaen)




(autoload 'google-translate-translate "google-translate" "" t)
(defun google-translate-get-string (arg)
  (or (cond ((stringp arg) arg)
        ((= arg 4)          ;C-u
         (thing-at-point 'paragraph))
        ((= arg 16)         ;C-u C-u
         (thing-at-point 'word))
        ((= arg 64)         ;C-u C-u C-u
         (read-string "Google Translate: "))
        ((use-region-p)         ;リージョン指定
         (buffer-substring (region-beginning) (region-end)))
        (t              ;デフォルト
         (thing-at-point 'sentence)))
      ""))

(defun google-translate-enja-or-jaen (arg)
  "regionか現在位置の単語を翻訳する。C-u付きでquery指定も可能"
  (interactive "p")
  (let* ((string (google-translate-get-string arg))
     (japanesep (string-match "\\cj" string)))
    (run-at-time 0.1 nil 'deactivate-mark)
    (google-translate-translate
     (if japanesep "ja" "en")
     (if japanesep "en" "ja")
     string)))

;; (push '("*Google Translate*" :height 0.5 :stick t) popwin:special-display-config)

(global-set-key (kbd "C-M-t") 'google-translate-enja-or-jaen)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.6 表示・装飾に関する設定                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P95-96 フェイス
;; リージョンの背景色を変更
(set-face-background 'region "darkgreen")

;; ▼要拡張機能インストール▼
;;; P96-97 表示テーマの設定
;; http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz

;;(require 'color-theme)




;; (when (require 'color-theme nil t)
 ;;テーマを読み込むための設定
;;  (color-theme-initialize)
;; ;;テーマhoberに変更する
 ;; (color-theme-hober))
 ;; (color-theme-charcoal-black))
 ;; (color-theme-comidia))
 ;; (color-theme-clarity))
 ;; (color-theme-goldenrod))
 ;; (color-theme-ld-dark))
 ;; (color-theme-midnight))
 ;; (color-theme-pok-wob))
 ;; (color-theme-simple-1))
 ;; (color-theme-billw))

 ;; (color-theme-andreas))
 ;; (color-theme-arjen))
 ;; (color-theme-bharadwaj-slate))
 ;; (color-theme-blue-mood))
 ;; (color-theme-blue-sea))
 ;; (color-theme-dark-blue2))
 ;; (color-theme-digital-ofs1))
 ;; (color-theme-emacs-21))
 ;; (color-theme-euphoria))
 ;; (color-theme-feng-shui))
 ;; (color-theme-gray30))
 ;; (color-theme-high-contrast))
 ;; (color-theme-jb-simple))
 ;; (color-theme-jsc-dark))
 ;; (color-theme-jsc-light))
 ;; (color-theme-jsc-light2))
 ;; (color-theme-late-night))
 ;; (color-theme-matrix))
 ;; (color-theme-parus))
 ;; (color-theme-resolve))
 ;; (color-theme-retro-orange))
 ;; (color-theme-shaman))
 ;; (color-theme-subtle-hacker))
 ;; (color-theme-vim-colors))
 ;; (color-theme-whateveryouwant))
 ;; (color-theme-wheat))
 ;; (color-theme-xemacs))
 ;; (color-theme-xp))



;;;; installしたthemeを使用
  ;; M-x load-theme   RET   seti

 ;; (load-theme 'seti t)
 ;; (load-theme 'atom-dark t)
 ;; (load-theme 'solarized-dark t)
 ;; (load-theme 'solarized-light t)

(load-theme 'ir-black t)
;; To use this theme, download it to ~/.emacs.d/themes. In your `.emacs' or
;; `init.el', add this line:
;;
   (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;;
;; Once you have reloaded your configuration (`eval-buffer'), do `M-x
;; load-theme' and select "ir-black".




;;; P97-99 フォントの設定
(when (eq window-system 'ns)
  ;; asciiフォントをMenloに
  (set-face-attribute 'default nil
                      :family "Menlo"
                      :height 170)
  ;; 日本語フォントをヒラギノ明朝 Proに
  (set-fontset-font
   nil 'japanese-jisx0208
   ;; 英語名の場合
   ;; (font-spec :family "Hiragino Mincho Pro"))
   (font-spec :family "ヒラギノ明朝 Pro"))
  ;; ひらがなとカタカナをモトヤシーダに
  ;; U+3000-303F	CJKの記号および句読点
  ;; U+3040-309F	ひらがな
  ;; U+30A0-30FF	カタカナ
  (set-fontset-font
  nil '(#x3040 . #x30ff)
   (font-spec :family "NfMotoyaCedar"))
  ;; フォントの横幅を調節する
  (setq face-font-rescale-alist
        '((".*Menlo.*" . 1.0)
          (".*Hiragino_Mincho_Pro.*" . 1.2)
          (".*nfmotoyacedar-bold.*" . 1.2)
          (".*nfmotoyacedar-medium.*" . 1.2)
          ("-cdac$" . 1.3))))

;; (when (eq system-type 'windows-nt)
;;   ;; asciiフォントをConsolasに
;;   (set-face-attribute 'default nil
;;                       :family "Consolas"
;;                       :height 120)
;;   ;; 日本語フォントをメイリオに
;;   (set-fontset-font
;;    nil
;;    'japanese-jisx0208
;;    (font-spec :family "メイリオ"))
;;   ;; フォントの横幅を調節する
;;   (setq face-font-rescale-alist
;;         '((".*Consolas.*" . 1.0)
;;           (".*メイリオ.*" . 1.15)
;;           ("-cdac$" . 1.3))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.7 ハイライトの設定                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P100 現在行のハイライト
;; (defface my-hl-line-face
;;   ;; 背景がdarkならば背景色を紺に
;;   '((((class color) (background dark))
;;      (:background "NavyBlue" t))
;;     ;; 背景がlightならば背景色を緑に
;;     (((class color) (background light))
;;      (:background "LightGoldenrodYellow" t))
;;     (t (:bold t)))
;;   "hl-line's my face")
;; (setq hl-line-face 'my-hl-line-face)
;; (global-hl-line-mode t)

;; P101 括弧の対応関係のハイライト
;; paren-mode：対応する括弧を強調して表示する
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
;; parenのスタイル: expressionは括弧内も強調表示
;; (setq show-paren-style 'expression)
;; フェイスを変更する
;; (set-face-background 'show-paren-match-face nil)
;; (set-face-underline-p 'show-paren-match-face "yellow")




(when window-system
  ;; In order to change your cursor or caret, what you want to do is:
  ;; Open your .emacs file and this line of code:
  (setq-default cursor-type 'box)
  ;; And to change the color:
  (set-cursor-color "#ffffff"))



;; (add-to-list 'default-frame-alist '(cursor-type . 'box)) ;; ボックス型カーソル
;; (add-to-list 'default-frame-alist '(cursor-type . 'hbar)) ;; 下線
;; (add-to-list 'default-frame-alist '(cursor-type . '(bar . 3)) ;; 幅3ポイントの縦棒カーソル
;; 指定できるカーソルの種類は、下の表の通りです。 hbar, hollow は Emacs 21 では使えないかもしれません。

;; 値	説明
;; t	デフォルトの形状を利用。
;; nil	カーソルを表示しません。
;; box	文字と同サイズのボックス型のカーソルを表示します。通常はこの形がデフォルトです。
;; bar	縦棒型のカーソルです。
;; (bar . 3)	幅が 3 ポイントの縦棒カーソルを表示します。
;; hbar	下線を表示します。
;; (hbar . 3)	下線の高さが 3 ポイントになります。
;; hollow	中抜きのカーソルです。定義されていない値を代入すると、hollow 型が適用されます。



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.8 バックアップとオートセーブ                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P102-103 バックアップとオートセーブの設定
;; バックアップファイルを作成しない
;; (setq make-backup-files nil) ; 初期値はt
;; オートセーブファイルを作らない
;; (setq auto-save-default nil) ; 初期値はt

;; バックアップファイルの作成場所をシステムのTempディレクトリに変更する
;; (setq backup-directory-alist
;;       `((".*" . ,temporary-file-directory)))
;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更する
;; (setq auto-save-file-name-transforms
;;       `((".*" ,temporary-file-directory t)))

;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
(when window-system
  (add-to-list 'backup-directory-alist
               (cons "." "~/.emacs.d/backups/"))
  (setq auto-save-file-name-transforms
        `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

  ;; オートセーブファイル作成までの秒間隔
  (setq auto-save-timeout 15)
  ;; オートセーブファイル作成までのタイプ間隔
  (setq auto-save-interval 60))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5.9 フック                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ファイルが #! から始まる場合、+xを付けて保存する
;; (add-hook 'after-save-hook
;;           'executable-make-buffer-file-executable-if-script-p)

;; ;; emacs-lisp-mode-hook用の関数を定義
;; (defun elisp-mode-hooks ()
;;   "lisp-mode-hooks"
;;   (when (require 'eldoc nil t)
;;     (setq eldoc-idle-delay 0.2)
;;     (setq eldoc-echo-area-use-multiline-p t)
;;     (turn-on-eldoc-mode)))

;; ;; emacs-lisp-modeのフックをセット
;; (add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.1 Elispをインストールしよう                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P113 拡張機能を自動インストール──auto-install
;; auto-installの設定
(when (require 'auto-install nil t)	; ←1●
  ;; 2●インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelisp の名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; 3●install-elisp の関数を利用可能にする
  (auto-install-compatibility-setup)) ; 4●


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  redo+   C-.                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ▼要拡張機能インストール▼
;;; P114-115 auto-installを利用する
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
(when (require 'redo+ nil t)
  ;; C-' にリドゥを割り当てる
  ;; (global-set-key (kbd "C-'") 'redo)
  ;; 日本語キーボードの場合C-. などがよいかも
  (global-set-key (kbd "C-.") 'redo)
)

;;
;; Installation:
;;
;; Save this file as redo+.el, byte compile it and put the
;; resulting redo.elc file in a directory that is listed in
;; load-path.
;;
;; In your .emacs file, add
;;   (require 'redo+)
;; and the system will be enabled.
;;
;; In addition, if you don't want to redo a previous undo, add
;;   (setq undo-no-redo t)
;; You can also use a function `undo-only' instead of `undo'
;; in GNU Emacs 22 or later.




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ELPA  パッケージマネージャー                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ▼要拡張機能インストール▼（ただし、Emacs24からはインストール不要）
;;; P115-116 Emacs Lisp Package Archive（ELPA）──Emacs Lispパッケージマネージャ
;; package.elの設定
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.2 統一したインタフェースでの操作  Anything                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P122-129 候補選択型インタフェース──Anything
;; (auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;; ;; ▼要拡張機能インストール▼
;; ;;; P127-128 過去の履歴からペースト──anything-show-kill-ring
;; ;; M-yにanything-show-kill-ringを割り当てる
 (define-key global-map (kbd "M-y") 'anything-show-kill-ring)

;; ;; ▼要拡張機能インストール▼
;; ;;; P128-129 moccurを利用する──anything-c-moccur
(when (require 'anything-c-moccur nil t)
  (setq
   ;; anything-c-moccur用 `anything-idle-delay'
   anything-c-moccur-anything-idle-delay 0.1
   ;; バッファの情報をハイライトする
   anything-c-moccur-higligt-info-line-flag t
   ;; 現在選択中の候補の位置をほかのwindowに表示する
   anything-c-moccur-enable-auto-look-flag t
   ;; 起動時にポイントの位置の単語を初期パターンにする
   anything-c-moccur-enable-initial-pattern t)
  ;; C-M-oにanything-c-moccur-occur-by-moccurを割り当てる
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'helm-config)

(require 'helm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.3 入力の効率化  auto-complete                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P130-131 利用可能にする
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories 
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.4 検索と置換の拡張                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P132 検索結果をリストアップする──color-moccur
;; color-moccurの設定
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる環境であればMigemoを使う
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-use-migemo t)))

;;; Install:
;; Put this file into load-path'ed directory, and byte compile it if
;; desired.  And put the following expression into your ~/.emacs.
;;
;;     (require 'color-moccur)

;; The latest version of this program can be downloaded from
;; http://www.bookshelf.jp/elc/color-moccur.el

;; moccur-edit.el
;;   With this packege, you can edit *moccur* buffer and apply
;;   the changes to the files.
;;   You can get moccur-edit.el at
;;   http://www.bookshelf.jp/elc/moccur-edit.el

;;; Functions
;; moccur, dmoccur, dired-do-moccur, Buffer-menu-moccur,
;; grep-buffers, search-buffers, occur-by-moccur
;; isearch-moccur
;; moccur-grep, moccur-grep-find

;;; usage:moccur
;; moccur <regexp> shows all occurrences of <regexp> in all buffers
;; currently existing that refer to files.
;; The occurrences are displayed in a buffer running in Moccur mode;
;;;; keybind
;; C-c C-c or RET gets you to the occurrence
;; q : quit
;; <up>, n, j   : next matches
;; <down>, p, k : previous matches
;; b :scroll-down in matched buffer
;; SPC : scroll-up in matched buffer
;; M-v :scroll-down in moccur buffer
;; C-v : scroll-up in moccur buffer
;; < : M-< in matched buffer
;; > : M-> in matched buffer
;; t : toggle whether a searched buffer is displayed to other window.
;; r : re-search in only matched buffers.
;; d,C-k : kill-line
;; M-x moccur-flush-lines : flush-lines for moccur
;; M-x moccur-keep-lines : keep-lines for moccur
;; / : undo (maybe doesn't work)
;; s : run moccur by matched bufffer only.
;; u : run moccur by prev condition

;;; usage:moccur-grep, moccur-grep-find
;; moccur-grep <regexp> shows all occurrences of <regexp> in files of current directory
;; moccur-grep-find <regexp> shows all occurrences of <regexp>
;;                  in files of current directory recursively.
;;
;;;; Variables of M-x moccur-grep(-find)
;; dmoccur-exclusion-mask : if filename matches the regular
;; expression, dmoccur/moccur-grep *doesn't* open the file.

;; ▼要拡張機能インストール▼
;;; P133-134 moccurの結果を直接編集──moccur-edit
;; moccur-editの設定
(require 'moccur-edit nil t)
;; moccur-edit-finish-editと同時にファイルを保存する
;; (defadvice moccur-edit-change-file
;;   (after save-after-moccur-edit-buffer activate)
;;   (save-buffer))
;;
;; "Moccur"バッファ上で r を押すことで、検索結果を直接編集できるmoccur-edit-modeになる
;; C-c C-u, C-x k, C-u C-k (moccur-edit-kill-all-change 編集を破棄)
;; C-c C-c  or  C-x C-s  編集内容がバッファへと反映されます
;; 編集をファイルに反映させるには C-x s(save-some-buffers)などを利用して保存

;; ▼要拡張機能インストール▼
;;; P136 grepの結果を直接編集──wgrep
;; wgrepの設定
(require 'wgrep nil t)

;; M-x grep, M-x rgrep, M-x lgrep で検索
;; C-c C-p "grep"バッファを編集
;; C-c C-k  編集を破棄
;; C-c C-c  編集を反映
;; ファイルは要別途保存
;;  M-x wgrep-save-all-buffers RET  wgrepによって編集したファイルのみ一括保存する




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.5 さまざまな履歴管理                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P137-138 編集履歴を記憶する──undohist
;; undohistの設定
(when (require 'undohist nil t)
  (undohist-initialize))

;; Write the following code to your .emacs:
;;
;; (require 'undohist)
;; (undohist-initialize)
;;
;; Now you can record and recover undohist by typing
;; C-x C-s (save-buffer) an C-x C-f (find-file).
;; And then type C-/ (undo).

;; ▼要拡張機能インストール▼
;;; P138 アンドゥの分岐履歴──undo-tree
;; ;; undo-treeの設定
;; (when (require 'undo-tree nil t)
;;   (global-undo-tree-mode))

;; ;; C-x u (undo-tree-visualize)
;; ;;  樹形図を移動するとバッファがアンドゥされていく
;; ;; "t" 樹形図を時間表示
;; ;; 戻りたいポイントに来たら"q"で抜ける


;; ▼要拡張機能インストール▼
;;; P139-140 カーソルの移動履歴──point-undo
;; ;; point-undoの設定
(when (require 'point-undo nil t)
  ;; (define-key global-map [f5] 'point-undo)
  ;; (define-key global-map [f6] 'point-redo)
  ;; 筆者のお勧めキーバインド
  (define-key global-map (kbd "M-[") 'point-undo)
  (define-key global-map (kbd "M-]") 'point-redo)
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emmet-mode                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when window-system
  (require 'emmet-mode)
  ;;
  ;; Example setup:
  ;;
  (add-to-list 'load-path "~/Emacs/emmet/")
  ;;   (require 'emmet-mode)
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
  (add-hook 'html-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook  'emmet-mode)
  (add-hook 'css-mode-hook  'emmet-mode))
;;
;; Enable the minor mode with M-x emmet-mode.
;;
;; See ``Test cases'' section for a complete set of expression types.
;;
;; If you are hacking on this project, eval (emmet-test-cases) to
;; ensure that your changes have not broken anything. Feel free to add
;; new test cases if you add new features.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; autopair                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Installation:
;;
(when window-system
   (require 'autopair)
   (autopair-global-mode)) ;; to enable in all buffers
;;
;; To enable autopair in just some types of buffers, comment out the
;; `autopair-global-mode' and put autopair-mode in some major-mode
;; hook, like:
;;
;; (add-hook 'c-mode-common-hook #'(lambda () (autopair-mode)))
;;
;; Alternatively, do use `autopair-global-mode' and create
;; *exceptions* using the `autopair-dont-activate' local variable (for
;; emacs < 24), or just using (autopair-mode -1) (for emacs >= 24)
;; like:
;;
;; (add-hook 'c-mode-common-hook
;;           #'(lambda ()
;;             (setq autopair-dont-activate t)
;;             (autopair-mode -1)))
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'cl)
;; 問い合わせを簡略化 yes/no を y/n
(fset 'yes-or-no-p 'y-or-n-p)



;; パスを通す
(add-to-list 'load-path
             (expand-file-name "~/.emacs.d/elpa/yasnippet-20180310.1614/"))

;; 自分用・追加用テンプレート -> mysnippetに作成したテンプレートが格納される
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/mysnippets"
        "~/.emacs.d/yasnippets"
        ))

;; 既存スニペットを挿入する
(define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
;; 新規スニペットを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
;; 既存スニペットを閲覧・編集する
(define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file)

(yas-global-mode 1)


;; M-x yas-describe-tables テンプレートの表示


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.6 ウィンドウ管理  ELScreen                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P141-143 ウィンドウの分割状態を管理──ElScreen
;; ElScreenのプレフィックスキーを変更する（初期値はC-z）
;; (setq elscreen-prefix-key (kbd "C-t"))
;; (when (require 'elscreen nil t)
;;   ;; C-z C-zをタイプした場合にデフォルトのC-zを利用する
;;   (if window-system
;;       (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
;;     (define-key elscreen-map (kbd "C-z") 'suspend-emacs)))

;; C-z T    Show/hide the tab at the top of screen

;; (when window-system
;;   (elscreen-start)
;;   (require 'elscreen nil t))

(require 'elscreen nil t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.7 メモ・情報整理  howm                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P144-146 メモ書き・ToDo管理──howm
;; howmメモ保存の場所
(setq howm-directory (concat user-emacs-directory "howm"))
;; howm-menuの言語を日本語に
(setq howm-menu-lang 'ja)
;; howmメモを1日1ファイルにする
; (setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")
;; howm-modeを読み込む
(when (require 'howm-mode nil t)
  ;; C-c,,でhowm-menuを起動
  (define-key global-map (kbd "C-c ,,") 'howm-menu))
;; howmメモを保存と同時に閉じる
(defun howm-save-buffer-and-kill ()
  "howmメモを保存と同時に閉じます。"
  (interactive)
  (when (and (buffer-file-name)
             (string-match "\\.howm" (buffer-file-name)))
    (save-buffer)
    (kill-buffer nil)))

;; C-c ,, で起動

;;  c  新規メモ


;; C-c C-cでメモの保存と同時にバッファを閉じる
(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode  P.149                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;~/Desktop/igen/memo.org

;; * 見出し１
;; ** 見出し２
;; *** 見出し３
;; **** 見出し４
;; ***** 見出し５ ;;見出しの上でTABで見出しの中を折りたたむことができる

;; - 箇条書きリスト ;;ここで M-RETすると次の行に - を自動挿入
;; - 箇条書きリスト
;;   + ネストした箇条書きリスト
;;   + ネストした箇条書きリスト

;; 1. 番号リスト
;; 2. 番号リスト
;; 3. 番号リスト
;; 4. 番号リスト



;; | A | B | C |
;; | - |   |   |
;; |---+---+---|
;; |   |   |   |


;; * 出来事１

;; ** 出来事２

;; *** 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6.8 特殊な範囲の編集                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; P151 矩形編集──cua-mode
;; cua-modeの設定
(cua-mode t)
(setq cua-enable-cua-keys nil) ; CUAキーバインドを無効にする

;; - List1  ;;C-RET
;; - List2
;; - List3  ;;"- " C-gで作業終了

;; 1.ListA  ;;C-@
;; 2.ListB
;; 3.ListC
;; 4.ListD  ;;C-RET M-o M-n 1 RET 1 RET %d. RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.1 各種言語の開発環境                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; P158 nxml-modeをHTML編集のデフォルトモードに
;; ;; HTML編集のデフォルトモードをnxml-modeにする
;; (add-to-list 'auto-mode-alist '("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'" . nxml-mode))
;; ;; ▼要拡張機能インストール▼
;; ;;; P159 HTML5をnxml-modeで編集する
;; ;; HTML5
;; (eval-after-load "rng-loc"
;;   '(add-to-list 'rng-schema-locating-files "~/.emacs.d/public_repos/html5-el/schemas.xml"))
;; (require 'whattf-dt)

;; ;;; P160 nxml-modeの基本設定
;; ;; </を入力すると自動的にタグを閉じる
;; (setq nxml-slash-auto-complete-flag t)
;; ;; M-TABでタグを補完する
;; (setq nxml-bind-meta-tab-to-complete-flag t)
;; ;; nxml-modeでauto-complete-modeを利用する
;; (add-to-list 'ac-modes 'nxml-mode)
;; ;; 子要素のインデント幅を設定する。初期値は2
;; (setq nxml-child-indent 0)
;; ;; 属性値のインデント幅を設定する。初期値は4
;; (setq nxml-attribute-indent 0)

;; ▼要拡張機能インストール▼
;; ;;; P161 cssm-modeの基本設定
;; (defun css-mode-hooks ()
;;   "css-mode hooks"
;;   ;; インデントをCスタイルにする
;;   (setq cssm-indent-function #'cssm-c-style-indenter)
;;   ;; インデント幅を2にする
;;   (setq cssm-indent-level 2)
;;   ;; インデントにタブ文字を使わない
;;   (setq-default indent-tabs-mode nil)
;;   ;; 閉じ括弧の前に改行を挿入する
;;   (setq cssm-newline-before-closing-bracket ))

;; (add-hook 'css-mode-hook 'css-mode-hooks)

;; ;;; P163 js-modeの基本設定
(defun js-indent-hook ()
  ;; インデント幅を2にする
  (setq js-indent-level 2
        js-expr-indent-offset 2
        indent-tabs-mode nil)
  ;; switch文のcaseラベルをインデントする関数を定義する
  (defun my-js-indent-line () ; ←1●
    (interactive)
    (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status)))
      (back-to-indentation)
      (if (looking-at "case\\s-")
          (indent-line-to (+ indentation 2))
        (js-indent-line))
      (when (> offset 0) (forward-char offset))))
  ;; caseラベルのインデント処理をセットする
  (set (make-local-variable 'indent-line-function) 'my-js-indent-line)
  ;; ここまでcaseラベルを調整する設定
  )

;; js-modeの起動時にhookを追加
(add-hook 'js-mode-hook 'js-indent-hook)




;; ▼要拡張機能インストール▼
;;; P165 php-mode
;; php-modeの設定
(when (require 'php-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))
  (setq php-search-url "http://jp.php.net/ja/")
  (setq php-manual-url "http://jp.php.net/manual/ja/"))

;;; P166 php-modeのインデントを調整する
;; php-modeのインデント設定
(defun php-indent-hook ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 2)
  ;; (c-set-offset 'case-label '+) ; switch文のcaseラベル
  (c-set-offset 'arglist-intro '+) ; 配列の最初の要素が改行した場合
  (c-set-offset 'arglist-close 0)) ; 配列の閉じ括弧

(add-hook 'php-mode-hook 'php-indent-hook)

;; ▼要拡張機能インストール▼
;;; P166-167 PHP補完入力──php-completion
;; php-modeの補完を強化する
(defun php-completion-hook ()
  (when (require 'php-completion nil t)
    (php-completion-mode t)
    (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)

    (when (require 'auto-complete nil t)
    (make-variable-buffer-local 'ac-sources)
    (add-to-list 'ac-sources 'ac-source-php-completion)
    (auto-complete-mode t))))

(add-hook 'php-mode-hook 'php-completion-hook)


;; P168-169 cperl-mode
;; ;; perl-modeをcperl-modeのエイリアスにする
 (defalias 'perl-mode 'cperl-mode)

;; ;;; P170 cperl-modeのインデントを調整する
;; cperl-modeのインデント設定
(setq cperl-indent-level 4 ; インデント幅を4にする
      cperl-continued-statement-offset 4 ; 継続する文のオフセット※
      cperl-brace-offset -4 ; ブレースのオフセット
      cperl-label-offset -4 ; labelのオフセット
      cperl-indent-parens-as-block t ; 括弧もブロックとしてインデント
      cperl-close-paren-offset -4 ; 閉じ括弧のオフセット
      cperl-tab-always-indent t ; TABをインデントにする
      cperl-highlight-variables-indiscriminately t) ; スカラを常にハイライトする

;; ;; ▼要拡張機能インストール▼
;; ;;; P170 yaml-mode
;; ;; yaml-modeの設定
(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))

;; ;; ▼要拡張機能インストール▼
;; ;;; P171 Perl補完入力──perl-completion
;; perl-completionの設定
(defun perl-completion-hook ()
  (when (require 'perl-completion nil t)
    (perl-completion-mode t)
    (when (require 'auto-complete nil t)
      (auto-complete-mode t)
      (make-variable-buffer-local 'ac-sources)
      (setq ac-sources
            '(ac-source-perl-completion)))))

(add-hook  'cperl-mode-hook 'perl-completion-hook)

;; C-RET か M-TAB で補完
;; C-c s (plcmp-cmd-show-doc-at-point)

;; ;;; P169 コラム 便利なエイリアス
;; ;; dtwをdelete-trailing-whitespaceのエイリアスにする
(defalias 'dtw 'delete-trailing-whitespace)
;; ;; M-x dtw  で行末の空白を削除

;; ;;; P172 ruby-modeのインデントを調整する
;; ;; ruby-modeのインデント設定
;; (setq ;; ruby-indent-level 3 ; インデント幅を3に。初期値は2
;;       ruby-deep-indent-paren-style nil ; 改行時のインデントを調整する
;;       ;; ruby-mode実行時にindent-tabs-modeを設定値に変更
;;       ;; ruby-indent-tabs-mode t ; タブ文字を使用する。初期値はnil
;;       ) 

;; ;; ▼要拡張機能インストール▼
;; ;;; P172-173 Ruby編集用の便利なマイナーモード
;; 括弧の自動挿入──ruby-electric
(require 'ruby-electric nil t)
;; endに対応する行のハイライト──ruby-block
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))
;; インタラクティブRubyを利用する──inf-ruby
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

;; ;; ruby-mode-hook用の関数を定義
(defun ruby-mode-hooks ()
  (inf-ruby-keys)
  (ruby-electric-mode t)
  (ruby-block-mode t))
;; ruby-mode-hookに追加
(add-hook 'ruby-mode-hook 'ruby-mode-hooks)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.2 Flymakeによる文法チェック                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M-x flymake-modeでflymakeによる文法チェック開始

;;; P182-183 Makefileがあれば利用し、なければ直接コマンドを実行する
;; Makefileの種類を定義
(defvar flymake-makefile-filenames
  '("Makefile" "makefile" "GNUmakefile")
  "File names for make.")

;; Makefileがなければコマンドを直接利用するコマンドラインを生成
(defun flymake-get-make-gcc-cmdline (source base-dir)
  (let (found)
    (dolist (makefile flymake-makefile-filenames)
      (if (file-readable-p (concat base-dir "/" makefile))
          (setq found t)))
    (if found
        (list "make"
              (list "-s"
                    "-C"
                    base-dir
                    (concat "CHK_SOURCES=" source)
                    "SYNTAX_CHECK_MODE=1"
                    "check-syntax"))
      (list (if (string= (file-name-extension source) "c") "gcc" "g++")
            (list "-o"
                  "/dev/null"
                  "-fsyntax-only"
                  "-Wall"
                  source)))))

;; Flymake初期化関数の生成
(defun flymake-simple-make-gcc-init-impl
  (create-temp-f use-relative-base-dir
                 use-relative-source build-file-name get-cmdline-f)
  "Create syntax check command line for a directly checked source file.
Use CREATE-TEMP-F for creating temp copy."
  (let* ((args nil)
         (source-file-name buffer-file-name)
         (buildfile-dir (file-name-directory source-file-name)))
    (if buildfile-dir
        (let* ((temp-source-file-name
                (flymake-init-create-temp-buffer-copy create-temp-f)))
          (setq args
                (flymake-get-syntax-check-program-args
                 temp-source-file-name
                 buildfile-dir
                 use-relative-base-dir
                 use-relative-source
                 get-cmdline-f))))
    args))

;; 初期化関数を定義
(defun flymake-simple-make-gcc-init ()
  (message "%s" (flymake-simple-make-gcc-init-impl
                 'flymake-create-temp-inplace t t "Makefile"
                 'flymake-get-make-gcc-cmdline))
  (flymake-simple-make-gcc-init-impl
   'flymake-create-temp-inplace t t "Makefile"
   'flymake-get-make-gcc-cmdline))

;; 拡張子 .c, .cpp, c++などのときに上記の関数を利用する
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'"
               flymake-simple-make-gcc-init))

;;; P184 XMLとHTML
;; XML用Flymakeの設定
(defun flymake-xml-init ()
  (list "xmllint" (list "--valid"
                        (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))))

;; HTML用Flymakeの設定
(defun flymake-html-init ()
  (list "tidy" (list (flymake-init-create-temp-buffer-copy
                      'flymake-create-temp-inplace))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.html\\'" flymake-html-init))

;; tidy error pattern
(add-to-list 'flymake-err-line-patterns
'("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
  nil 1 2 4))

;;; P185-186 JavaScript
;; JS用Flymakeの初期化関数の定義
(defun flymake-jsl-init ()
  (list "jsl" (list "-process" (flymake-init-create-temp-buffer-copy
                                'flymake-create-temp-inplace))))
;; JavaScript編集でFlymakeを起動する
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.js\\'" flymake-jsl-init))

(add-to-list 'flymake-err-line-patterns
 '("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning\\|SyntaxError\\): \\(.*\\)"
   1 2 nil 4))

;;; P186 Ruby
;; Ruby用Flymakeの設定
(defun flymake-ruby-init ()
  (list "ruby" (list "-c" (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.rb\\'" flymake-ruby-init))

(add-to-list 'flymake-err-line-patterns
             '("\\(.*\\):(\\([0-9]+\\)): \\(.*\\)" 1 2 nil 3))

;; ▼要拡張機能インストール▼
;;; P187 Python
;; ;; Python用Flymakeの設定
;; ;; (install-elisp "https://raw.github.com/seanfisk/emacs/sean/src/flymake-python.el")
;; (when (require 'flymake-python nil t)
;;   ;; flake8を利用する
;;   (when (executable-find "flake8")
;;     (setq flymake-python-syntax-checker "flake8"))
;;   ;; pep8を利用する
;;   ;; (setq flymake-python-syntax-checker "pep8")
;;   )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.3 タグによるコードリーディング                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P189-190 gtagsとEmacsとの連携
;; gtags-modeのキーバインドを有効化する
;;(setq gtags-suggested-key-mapping t) ; 無効化する場合はコメントアウト
;;(require 'gtags nil t)


;; ▼要拡張機能インストール▼
;;; P190-191 ctagsとEmacsとの連携
;; ctags.elの設定
(require 'ctags nil t)
(setq tags-revert-without-query t)
;; ctagsを呼び出すコマンドライン。パスが通っていればフルパスでなくてもよい
;; etags互換タグを利用する場合はコメントを外す
;; (setq ctags-command "ctags -e -R ")
;; anything-exuberant-ctags.elを利用しない場合はコメントアウトする
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

;; ▼要拡張機能インストール▼
;;; P192-193 Anythingとタグの連携
;; AnythingからTAGSを利用しやすくするコマンド作成

(when (and (require 'anything-exuberant-ctags nil t)
           (require 'anything-gtags nil t))
  ;; anything-for-tags用のソースを定義
  (setq anything-for-tags
        (list anything-c-source-imenu
              anything-c-source-gtags-select
              ;; etagsを利用する場合はコメントを外す
              ;; anything-c-source-etags-select
              anything-c-source-exuberant-ctags-select
              ))

  ;; anything-for-tagsコマンドを作成
  (defun anything-for-tags ()
    "Preconfigured `anything' for anything-for-tags."
    (interactive)
    (anything anything-for-tags
              (thing-at-point 'symbol)
              nil nil nil "*anything for tags*"))
  
  ;; M-tにanything-for-currentを割り当て
  (define-key global-map (kbd "M-t") 'anything-for-tags))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.4 フレームワーク専用拡張機能                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P195-196 Rinari
;;(when (require 'rhtml-mode nil t)
;;  (add-to-list 'auto-mode-alist '("\\.rhtml\\'" . rhtml-mode)))

;; ▼要拡張機能インストール▼
;;; P197-200 CakePHP Minor Mode
;;;; CakePHP 1系統のemacs-cake
;;(when (require 'cake nil t)
;;  ;; emacs-cakeの標準キーバインドを利用する
;;  (cake-set-default-keymap)
;;  ;; 標準でemacs-cakeをオン
;;  (global-cake t))
;; 
;;;; CakePHP 2系統のemacs-cake
;;(when (require 'cake2 nil t)
;;  ;; emacs-cake2の標準キーバインドを利用する
;;  (cake2-set-default-keymap)
;;  ;; 標準でemacs-cake2をオフ
;;  (global-cake2 -1))
;; 
;;;; emacs-cakeを切り替えるコマンドを定義
;;(defun toggle-emacs-cake ()
;;  "emacs-cakeとemacs-cake2を切り替える"
;;  (interactive)
;;  (cond ((eq cake2 t) ; cake2がオンであれば
;;         (cake2 -1) ; cake2をオフにして
;;         (cake t)) ; cakeをオンにする
;;        ((eq cake t) ; cakeがオンであれば
;;         (cake -1) ; cakeをオフにして
;;         (cake2 t)) ; cake2をオンにする
;;        (t nil))) ; どちらもオフであれば何もしない
;; 
;;;; C-c tにtoggle-emacs-cakeを割り当て
;;(define-key cake-key-map (kbd "C-c t") 'toggle-emacs-cake)
;;(define-key cake2-key-map (kbd "C-c t") 'toggle-emacs-cake)

;; ▼要拡張機能インストール▼
;;; P201 auto-completeと連携する
;; auto-complete, ac-cake, ac-cake2の読み込みをチェック
;;(when (and (require 'auto-complete nil t)
;;           (require 'ac-cake nil t)
;;           (require 'ac-cake2 nil t))
;;  ;; ac-cake用の関数定義
;;  (defun ac-cake-hook ()
;;    (make-variable-buffer-local 'ac-sources)
;;    (add-to-list 'ac-sources 'ac-source-cake)
;;    (add-to-list 'ac-sources 'ac-source-cake2))
;;  ;; php-mode-hookにac-cake用の関数を追加
;;  (add-hook 'php-mode-hook 'ac-cake-hook))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.5 特殊な文字の入力補助                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ▼要拡張機能インストール▼
;;; P201-202 絵文字の入力補助 emoji.el
;; (require 'emoji)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.6 差分とマージ                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-x diff RET ~/tmp/example.txt RET ~/tmp/example.txt.old RET (差分表示)

;;M-x ediff RET ~/tmp/example.txt.old RET ~/tmp/example.txt RET (差分視覚的表示)

;;; P206 同一フレーム内にコントロールパネルを表示する
;; ediffコントロールパネルを別フレームにしない
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; n,p で差分移動  | でウィンドウ分割切り替え  wd で差分ファイルに出力(パッチを作成)


;; Ediffによるパッチの適用  M-x epatch

;; Ediffによるマージ  M-x ediff-merge


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.7 Emacsからデータベースを操作                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-x sql-データベース名 (Emacsからデータベースへ接続)

;; example.sqlというファイルを作成し
;; M-x sql-set-sqli-buffer-generallyを実行
;; *SQLi*バッファと関連づけられる
;; example.sqlファイルに show tables;と記述し C-c C-cをタイプ
;; example.sqlに記述したSQL文が*SQLi*バッファ上で実行されます



;;; P210-211 MySQLへ接続する──sql-interactive-mode
;; SQLサーバへ接続するためのデフォルト情報
;; (setq sql-user "root" ; デフォルトユーザ名
;;       sql-database "database_name" ;  データベース名
;;       sql-server "localhost" ; ホスト名
;;       sql-product 'mysql) ; データベースの種類





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.8 バージョン管理                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs標準搭載バージョン管理システム用インターフェース VC
;; P.214


;; ▼要拡張機能インストール▼
;;; P215-216 Subversionフロントエンド psvn
(when (executable-find "svn")
  (setq svn-status-verbose nil)
  (autoload 'svn-status "psvn" "Run `svn status'." t))

;; M-x svn-status   RET
;; n,pでファイル移動、aでファイルを追加、mでマーク、uでアンマーク、cでコミットメッセージの入力バッファとなり、C-c C-c でコミット完了
;; U で svn up を実行  P.217

;; ▼要拡張機能インストール▼
;;; P217-219 Gitフロントエンド Egg
;; GitフロントエンドEggの設定
(when (executable-find "git")
  (require 'egg nil t))

;; C-x v s (egg-status)

;; n,p ファイル、差分単位でジャンプ  カーソル+s で、ステージ、アンステージ
;; ステージ済みのファイルをコミット c コミットメッセージを入力して C-c C-c でコミット完了
;; C-x v l (egg-log)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.9 シェルの利用                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-! (shell-command) ミニバッファ
;; M-! date RET  現在時刻

;; C-u M-! カレントファイルへ結果を出力
;; C-u M-! ls -l RET    (Users/inomoto/)

;; C-u M-| grep "Do" RET  リージョンがgrepで処理された結果に置換される



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; multi-term                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; プロンプトの崩れを治す
;; disable menu-bar
;;  (menu-bar-mode -1)


;; ▼要拡張機能インストール▼
;;; ターミナルの利用 multi-term
;;(require 'multi-term)



;; ;; Emacs が保持する terminfo を利用する
;; (setq system-uses-terminfo nil)

;; (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)





;; ;;multi-term
;; (setq load-path(cons "~/.emacs.d/" load-path))
;; (setq multi-term-program "/bin/zsh")
;; (require 'multi-term)

;; ;; emacs に認識させたいキーがある場合は、term-unbind-key-list に追加する
;; (add-to-list 'term-unbind-key-list "C-\\") ; IME の切り替えを有効とする
;; (add-to-list 'term-unbind-key-list "C-o")  ; IME の切り替えに C-o を設定している場合
 
;; ;; terminal に直接通したいキーがある場合は、以下をアンコメントする
;; ;; (delete "<ESC>" term-unbind-key-list)
;; ;; (delete "C-h" term-unbind-key-list)
;; ;; (delete "C-z" term-unbind-key-list)
;; ;; (delete "C-x" term-unbind-key-list)
;; ;; (delete "C-c" term-unbind-key-list)
;; ;; (delete "C-y" term-unbind-key-list)

;; ;; C-c m で multi-term を起動する
;; (global-set-key (kbd "C-c m") 'multi-term)

;; ;;;; multi-termの設定
;; ;;(when (require 'multi-term nil t)
;; ;;  ;; 使用するシェルを指定
;; ;;  (setq multi-term-program "/usr/local/bin/zsh"))

;; ;; M-x multi-term    ;; exit で終了

;; ;; You can run the command ‘multi-term’ with M-x mu-t RET





;; Emacs 上で快適に Bash や Zsh を利用する設定
;; http://sakito.jp/emacs/emacsshell.html

(require 'multi-term)
(setq multi-term-program shell-file-name)

(add-to-list 'term-unbind-key-list '"M-x")



;; (add-hook 'term-mode-hook
;;          '(lambda ()
;;             ;; C-h を term 内文字削除にする
;;             (define-key term-raw-map (kbd "C-h") 'term-send-backspace)
;;             ;; C-y を term 内ペーストにする
;;             (define-key term-raw-map (kbd "C-y") 'term-paste)
;;             ;; C-m を term 内newline-and-indentにする
;;             (define-key term-raw-map (kbd "C-m") 'term-newline)
;;             ))


;; (global-set-key (kbd "C-c m") '(lambda ()
;;                                 (interactive)
;;                                 (multi-term)))


(global-set-key (kbd "C-c m") '(lambda ()
                                (interactive)
                                (if (get-buffer "*terminal<1>*")
                                    (switch-to-buffer "*terminal<1>*")
                                (multi-term))))


(global-set-key (kbd "C-c n") 'multi-term-next)
(global-set-key (kbd "C-c p") 'multi-term-prev)



;; ;; shell-pop

;; (require 'shell-pop)
;; ;; multi-term に対応
;; (add-to-list 'shell-pop-internal-mode-list '("multi-term" "*terminal<1>*" '(lambda () (multi-term))))
;; (shell-pop-set-internal-mode "multi-term")
;; ;; 25% の高さに分割する
;; (shell-pop-set-window-height 25)
;; (shell-pop-set-internal-mode-shell shell-file-name)
;; ;; ショートカットも好みで変更してください
;; (global-set-key [f8] 'shell-pop)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.10 TRAMPによるサーバ接続                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C-x C-f (find-file) から  /sshx:ユーザ名@ホスト名:  と入力でそのままサーバに接続

;; C-x C-f  から   /su: 、もしくは  /sudo:  でファイルを開いて編集

;;; P225 バックアップファイルを作成しない
;; TRAMPでバックアップファイルを作成しない
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7.11 ドキュメント閲覧・検索                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-x man


;; M-x woman RET コマンド名 RET

;; M-p (WoMan-previous-manpage)  M-n  (WoMan-next-manpage)



;;; P226-228 Emacs版manビューア（WoMan）の利用
;; キャッシュを作成
(setq woman-cache-filename "~/.emacs.d/.wmncach.el")

;; C-u M-x woman RET  でキャッシュを更新できる


;; manパスを設定
(setq woman-manpath '("/usr/share/man"
                      "/usr/local/share/man"
                      "/usr/local/share/man/ja"))


;; ▼要拡張機能インストール▼
;; anything-for-document用のソースを定義
(setq anything-for-document-sources
      (list anything-c-source-man-pages
            anything-c-source-info-cl
            anything-c-source-info-pages
            anything-c-source-info-elisp
            anything-c-source-apropos-emacs-commands
            anything-c-source-apropos-emacs-functions
            anything-c-source-apropos-emacs-variables))

;; anything-for-documentコマンドを作成
(defun anything-for-document ()
  "Preconfigured `anything' for anything-for-document."
  (interactive)
  (anything anything-for-document-sources
            (thing-at-point 'symbol) nil nil nil
            "*anything for document*"))

;; Command+d に  M-x anything-for-document を割り当て
(define-key global-map (kbd "s-d") 'anything-for-document)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;            オマケ                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; カーソル位置のファイルパスやアドレスを "C-x C-f" で開く
(ffap-bindings)


;;; 筆者のキーバインド設定
;; Mac の Command + f で anything-for-files
(define-key global-map (kbd "s-f") 'anything-for-files)
;; Mac の C-x b で anything-for-files
;;(define-key global-map (kbd "C-x b") 'anything-for-files)
;; M-k でカレントバッファを閉じる
;;(define-key global-map (kbd "M-k") 'kill-this-buffer)
;;;; Mac の command + 3 でウィンドウを左右に分割
;;(define-key global-map (kbd "s-3") 'split-window-horizontally)
;;;; Mac の Command + 2 でウィンドウを上下に分割
;;(define-key global-map (kbd "s-2") 'split-window-vertically)
;;;; Mac の Command + 1 で現在のウィンドウ以外を閉じる
;;(define-key global-map (kbd "s-1") 'delete-other-windows)
;;;; Mac の Command + 0 で現在のウィンドウを閉じる
;;(define-key global-map (kbd "s-0") 'delete-window)
;; バッファを全体をインデント
(defun indent-whole-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))
;; C-<f8> でバッファ全体をインデント
(define-key global-map (kbd "C-<f8>") 'indent-whole-buffer)


;;; 改行やタブを可視化する whitespace-mode
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□]) ; zenkaku space
        (newline-mark 10 [8629 10]) ; newlne
        (tab-mark 9 [187 9] [92 9]) ; tab » 187
        )
      whitespace-style
      '(spaces
        ;; tabs
        trailing
        newline
        space-mark
        tab-mark
        newline-mark))
;; whitespace-modeで全角スペース文字を可視化　
(setq whitespace-space-regexp "\\(\x3000+\\)")
;; whitespace-mode をオン
(global-whitespace-mode t)
;; F5 で whitespace-mode をトグル
(define-key global-map (kbd "C-<f5>") 'global-whitespace-mode)


;;; Mac でファイルを開いたときに、新たなフレームを作らない
(setq ns-pop-up-frames nil)


;;; 最近閉じたバッファを復元
;;;; http://d.hatena.ne.jp/kitokitoki/20100608/p2
;;(defvar my-killed-file-name-list nil)
;; 
;;(defun my-push-killed-file-name-list ()
;;  (when (buffer-file-name)
;;    (push (expand-file-name (buffer-file-name)) my-killed-file-name-list)))
;; 
;;(defun my-pop-killed-file-name-list ()
;;  (interactive)
;;  (unless (null my-killed-file-name-list)
;;    (find-file (pop my-killed-file-name-list))))
;;;; kill-buffer-hook (バッファを消去するときのフック) に関数を追加
;;(add-hook 'kill-buffer-hook 'my-push-killed-file-name-list)
;;;; Mac の Command + z で閉じたバッファを復元する
;;(define-key global-map (kbd "s-z") 'my-pop-killed-file-name-list)
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; )
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; )
