(require 'ert)
(require 'undercover)

(undercover "org-toodledo.el")

(require 'org-toodledo)

(defun org-toodledo-test-setup-buffer (name)
  (let ((buf (get-buffer-create name)))
    (set-buffer buf)
    (erase-buffer)
    (when (not (eq major-mode 'org-mode))
      (org-mode))
    (insert "* TASKS
** WAITING [#D] Test2   :@work: 
    :PROPERTIES:
    :ToodledoID: 393773069  
    :Hash:     3da632c2b88319569f648c35506cf0ba 
    :Parent-id:
    :END:
** TODO [#D] Test1      :@work:
    DEADLINE: <2015-02-07 土 +1m>
    :PROPERTIES:
    :ToodledoID: 393655887
    :Hash:     ad0d9f84a6a204e051925805181ed137
    :Parent-id:
    :LAST_REPEAT: [2015-01-14 水 16:52]
    :END:")))

(defun org-toodledo-parse-test ()
  "Parse the org task at point and extract all toodledo related fields.  Return
an alist of the task fields."
  (save-excursion
    (org-back-to-heading t)
    (looking-at org-complex-heading-regexp)
    (match-string-no-properties 2)))

(ert-deftest org-toodledo-parse-test ()
  (setq org-toodledo-userid   (getenv "ToodledoID")
        org-toodledo-password (getenv "ToodledoPass"))
  (setq expected '(("repeatfrom" . "0")
                   ("repeat" . "Every 1 month")
                   ("duedate" . "1423267200")
                   ("duetime" . "0")
                   ("starttime" . "0")
                   ("startdate" . "0")
                   ("goal" . "0")
                   ("folder" . "0")
                   ("id" . "393655887")
                   ("title" . "Test1")
                   ("length" . "0")
                   ("context" . "1200627")
                   ("tag" . "")
                   ("completed" . "0")
                   ("status" . "2")
                   ("priority" . "0")
                   ("note" . "")))
    (org-toodledo-test-setup-buffer "*test*")
    (setq actual (org-toodledo-parse-current-task))
    (should (equal expected actual)))
