((nil . ((eval . (progn
                   ;; Set up local package directory
                   (setq package-user-dir (expand-file-name ".emacs.d.local" default-directory))
                   (setq package-gnupghome-dir (expand-file-name "gnupg" package-user-dir))

                   ;; Initialize package system
                   (require 'package)
                   (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                                            ("org" . "https://orgmode.org/elpa/")
                                            ("elpa" . "https://elpa.gnu.org/packages/")))
                   (package-initialize)

                   ;; Define and install required packages
                   (setq my-packages
                         '(csharp-mode company flycheck projectile magit format-all))

                   (dolist (package my-packages)
                     (unless (package-installed-p package)
                       (package-refresh-contents)
                       (package-install package)))

                   ;; Load and configure packages
                   (require 'csharp-mode)
                   (require 'company)
                   (require 'flycheck)
                   (require 'projectile)
                   (require 'magit)
                   (require 'format-all)

                   ;; C# mode hooks
                   (add-hook 'csharp-mode-hook #'company-mode)
                   (add-hook 'csharp-mode-hook #'flycheck-mode)
                   (add-hook 'csharp-mode-hook #'format-all-mode)

                   ;; XAML mode hooks
                   (add-hook 'nxml-mode-hook #'company-mode)
                   (add-to-list 'auto-mode-alist '("\\.xaml\\'" . nxml-mode))

                   ;; C# indentation
                   (setq csharp-indent-offset 4)

                   ;; Flycheck settings
                   (setq flycheck-csharp-language-version "7.3")
                   (setq flycheck-msbuild-exe "C:/Program Files (x86)/Microsoft Visual Studio/2019/Professional/MSBuild/Current/Bin/amd64/MSBuild.exe")
                   (setq flycheck-csharp-csc-executable "C:/Program Files (x86)/Microsoft Visual Studio/2019/Professional/MSBuild/Current/Bin/Roslyn/csc.exe")

                   ;; Projectile settings
                   (when (fboundp 'projectile-mode)
                     (projectile-mode +1)
                     (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

                   ;; Magit shortcut
                   (global-set-key (kbd "C-x g") 'magit-status)

                   ;; Variable to store the last built executable path
                   (defvar last-built-csharp-executable nil)

                   ;; Function to build C# file
                   (defun build-csharp ()
                     "Compile the current C# file."
                     (interactive)
                     (let* ((filename (file-name-nondirectory buffer-file-name))
                            (basename (file-name-sans-extension filename))
                            (build-dir (concat (file-name-directory buffer-file-name) "build/"))
                            (exe-path (concat build-dir basename ".exe"))
                            (csc-path "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Professional\\MSBuild\\Current\\Bin\\Roslyn\\csc.exe")
                            (compile-command (format "cmd /c \"\"%s\" /out:\"%s\" \"%s\"\"" 
                                                     csc-path exe-path buffer-file-name)))
                       ;; Create build directory if it doesn't exist
                       (unless (file-exists-p build-dir)
                         (make-directory build-dir t))
                       ;; Compile the C# file
                       (compile compile-command)
                       ;; Store the executable path
                       (setq last-built-csharp-executable exe-path)))

                   ;; Function to run C# executable
                   (defun run-csharp ()
                     "Run the last built C# executable."
                     (interactive)
                     (if last-built-csharp-executable
                         (let ((output-buffer (get-buffer-create "*C# Output*")))
                           (with-current-buffer output-buffer
                             (erase-buffer)
                             (insert (format "Running %s...\n\n" last-built-csharp-executable))
                             (let ((process (start-process "csharp-process" output-buffer "cmd.exe" "/c" last-built-csharp-executable)))
                               (set-process-sentinel
                                process
                                (lambda (proc event)
                                  (when (string-match "finished" event)
                                    (process-send-string proc "\n")))))
                             (display-buffer output-buffer))
                           (delete-other-windows)
                           (split-window-right)
                           (other-window 1)
                           (switch-to-buffer output-buffer))
                       (message "No C# executable has been built yet. Use F5 to build first.")))

                   ;; Bind build-csharp to F5 and run-csharp to F6
                   (local-set-key [f5] 'build-csharp)
                   (local-set-key [f6] 'run-csharp)
                   )))))
