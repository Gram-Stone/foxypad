#lang racket/base

(require framework
         gregor
         racket/class
         racket/gui/base)

(provide main)

(define (main)
  (define w 1150)
  (define h 600)
  (define current-filename "Untitled")
  (define current-title (string-append current-filename " - Foxypad"))
  (define f (new frame%
                 [label current-title]
                 [width w]
                 [height h]))
  
  (define menu-bar (new menu-bar% [parent f]))
  
  (define file-menu (new menu% [label "File"] [parent menu-bar]))

  (new menu-item%
       [label "New"]
       [parent file-menu]
       [callback
        (λ (i e)
          (send t erase)
          (set! current-filename "Untitled"))]
       [shortcut #\n]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "New Window"]
       [parent file-menu]
       [callback
        (λ (i e)
          (main))]
       [shortcut #\n]
       [shortcut-prefix '(ctl shift)])

  (new menu-item%
       [label "Open..."]
       [parent file-menu]
       [callback
        (λ (i e)
          (send t load-file (send t get-file #f)))]
       [shortcut #\o]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Save"]
       [parent file-menu]
       [callback
        (λ (i e)
          (void))]
       [shortcut #\s]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Save As..."]
       [parent file-menu]
       [callback
        (λ (i e)
          (send t save-file (send t put-file #f #f)))]
       [shortcut #\s]
       [shortcut-prefix '(ctl shift)])

  (new separator-menu-item% [parent file-menu])

  (new menu-item%
       [label "Page Setup..."]
       [parent file-menu]
       [callback
        (λ (i e)
          (get-page-setup-from-user "Page Setup"
                                    f))])

  (new menu-item%
       [label "Print..."]
       [parent file-menu]
       [callback
        (λ (i e)
          (send t print))]
       [shortcut #\p]
       [shortcut-prefix '(ctl)])

  (new separator-menu-item% [parent file-menu])

  (new menu-item%
       [label "Exit"]
       [parent file-menu]
       [callback
        (λ (i e)
          (exit:exit))])

  (define edit-menu (new menu% [label "Edit"] [parent menu-bar]))

  (new menu-item%
       [label "Undo"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t do-edit-operation 'undo))]
       [shortcut #\z]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Redo"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t do-edit-operation 'redo))]
       [shortcut #\y]
       [shortcut-prefix '(ctl)])

  (new separator-menu-item% [parent edit-menu])

  (new menu-item%
       [label "Cut"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t cut))]
       [shortcut #\x]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Copy"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t copy))]
       [shortcut #\c]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Paste"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t paste))]
       [shortcut #\v]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Delete"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t delete))]
       [shortcut #\rubout]
       [shortcut-prefix null])

  (new separator-menu-item% [parent edit-menu])

  (new menu-item%
       [label "Find..."]
       [parent edit-menu]
       [callback
        (λ (i e)
          (void))]
       [shortcut #\f]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Find Next"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (void))]
       [shortcut 'f3]
       [shortcut-prefix null])

  (new menu-item%
       [label "Find Previous"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (void))]
       [shortcut 'f3]
       [shortcut-prefix '(shift)])

  (new menu-item%
       [label "Replace..."]
       [parent edit-menu]
       [callback
        (λ (i e)
          (void))]
       [shortcut #\h]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Go To..."]
       [parent edit-menu]
       [callback
        (λ (i e)
          (void))]
       [shortcut #\g]
       [shortcut-prefix '(ctl)])

  (new separator-menu-item% [parent edit-menu])

  (new menu-item%
       [label "Select All"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t select-all))]
       [shortcut #\a]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Time/Date"]
       [parent edit-menu]
       [callback
        (λ (i e)
          (send t insert (make-object string-snip% (parameterize ([current-locale "en"])
                                                     (~t (now) "h:mm a MM/dd/YYYY")))))]
       [shortcut 'f5]
       [shortcut-prefix null])

  (define format-menu (new menu% [label "Format"] [parent menu-bar]))

  (new menu-item%
       [label "Word Wrap"]
       [parent format-menu]
       [callback
        (λ (i e)
          (void))])

  (new menu-item%
       [label "Font..."]
       [parent format-menu]
       [callback
        (λ (i e)
          (void))])

  (define view-menu (new menu% [label "View"] [parent menu-bar]))

  (define zoom-submenu (new menu% [label "View"] [parent view-menu]))

  (new menu-item%
       [label "Zoom In"]
       [parent zoom-submenu]
       [callback
        (λ (i e)
          (void))]
       [shortcut #\+]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Zoom Out"]
       [parent zoom-submenu]
       [callback
        (λ (i e)
          (void))]
       [shortcut #\-]
       [shortcut-prefix '(ctl)])

  (new menu-item%
       [label "Restore Default Zoom"]
       [parent zoom-submenu]
       [callback
        (λ (i e)
          (void))]
       [shortcut #\0]
       [shortcut-prefix '(ctl)])

  (new checkable-menu-item%
       [label "Status Bar"]
       [parent view-menu]
       [callback
        (λ (i e)
          (void))])

  (define help-menu (new menu% [label "Help"] [parent menu-bar]))

  (new menu-item%
       [label "View Help"]
       [parent help-menu]
       [callback
        (λ (i e)
          (void))])

  (new separator-menu-item% [parent help-menu])

  (new menu-item%
       [label "About Foxypad"]
       [parent help-menu]
       [callback
        (λ (i e)
          (void))])

  (define c (new editor-canvas% [parent f]))
  
  (define t (new text%))
  
  (send c set-editor t)
  
  (send t set-max-undo-history 100)

  (define default-style-delta (make-object style-delta%))
  
  (send t change-style (send (make-object style-delta%) set-delta-face "Inconsolata"))

  (send t change-style (make-object style-delta% 'change-size 11))
  
  (send f create-status-line)
  
  (send f show #t))