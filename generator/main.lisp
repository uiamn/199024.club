(load "generator/reviser.lisp")
(load "generator/header-generator.lisp")
(load "generator/footer-generator.lisp")

(defun all-content-path () (
    sort (directory (concatenate 'string (car *args*) "/**/????????")) #'string> :key #'pathname-name
))

(defun count-top-spaces (line n) (
    if (eq (char line 0) #\Space)
        (count-top-spaces (subseq line 1) (1+ n))
        n
))

(defun top-spaces-trim (line) (string-left-trim '(#\Space) line))

(defun next-top-spaces-stack (top-spaces top-spaces-stack) (
    cond
        ((eq top-spaces (car top-spaces-stack)) top-spaces-stack)
        ((> top-spaces (car top-spaces-stack)) (cons top-spaces top-spaces-stack))
        (t (next-top-spaces-stack top-spaces (cdr top-spaces-stack)))
))

(defun path-to-date-text (entry-path) (
    let ((filename (file-namestring entry-path))) (
        concatenate 'string
            (subseq filename 0 4)
            " 年 "
            (
                let ((c (aref filename 4))) (
                    if (eq c #\0) "" (string c)
                )
            )
            (string (aref filename 5))
            " 月 "
            (
                let ((c (aref filename 6))) (
                    if (eq c #\0) "" (string c)
                )
            )
            (string (aref filename 7))
            " 日"
    )
))

(defstruct token (is-indent nil) (is-dedent nil) (is-special nil) (text nil))

(defun make-text-token (rawline) (
    let* (
        (trimmed (top-spaces-trim rawline))
        (is-special (eq (char trimmed 0) #\!))
    )
        (make-token
            :is-special is-special
            :text (if is-special trimmed (revise trimmed))
        )
))

(defun repeat (elm n result)
    (cons elm (if (= n 1) nil (repeat elm (1- n) result)))
)

(defun parse (entry-path) (
    with-open-file (f entry-path :direction :input)
        (
            let (
                (tokens nil)
                (top-spaces-stack '(0))
                (top-spaces nil)
                (old-top-spaces-stack-size 0)
            )
                (loop for line = (read-line f nil) while line do
                    (if (string= line "")
                        ()
                        (progn
                            (setq top-spaces (count-top-spaces line 0))
                            (setq old-top-spaces-stack-size (length top-spaces-stack))
                            (setq top-spaces-stack (next-top-spaces-stack top-spaces top-spaces-stack))
                            (cond
                                (
                                    (= old-top-spaces-stack-size (length top-spaces-stack))
                                        (setq tokens (append tokens (list (make-text-token line))))
                                )
                                (
                                    (< old-top-spaces-stack-size (length top-spaces-stack))
                                        (setq tokens (append tokens (list (make-token :is-indent t) (make-text-token line))))
                                )
                                (   t
                                        (setq tokens (append
                                            tokens
                                            (repeat (make-token :is-dedent t) (- old-top-spaces-stack-size (length top-spaces-stack) ) nil)
                                            (list (make-text-token line))
                                        ))
                                )
                            )
                        )
                    )
                )
                (setq tokens (append tokens (repeat (make-token :is-dedent t) (1- (length top-spaces-stack)) nil)))
                tokens
        )
))

(defun generate-div-inner (parsed depth) (
    cond
        ((null parsed) "")
        ((token-is-indent (car parsed)) (concatenate 'string "<ul>" (generate-div-inner (cdr parsed) (1+ depth))))
        ((token-is-dedent (car parsed)) (concatenate 'string "</ul>" (generate-div-inner (cdr parsed) (1- depth))))
        ((token-is-special (car parsed)) (concatenate 'string (special-token (car parsed)) (generate-div-inner (cdr parsed) depth)))
        ((= depth 0) (concatenate 'string "<h3>" (token-text (car parsed)) "</h3>" (generate-div-inner (cdr parsed) depth)))
        (t (concatenate 'string "<li>" (token-text (car parsed)) "</li>" (generate-div-inner (cdr parsed) depth)))
))

(defun generate-entry-div (entry-path) (
    with-open-file (f entry-path :direction :input) (
        concatenate 'string
            "<div class=\"entry\" id=\"day"
            (subseq (file-namestring entry-path) 6 8)
            "\"><h2>■ "
            (path-to-date-text entry-path)
            "</h2>"
            (generate-div-inner (parse entry-path) 0)
            "</div>"
    )
))

(
    with-open-file
        (outs (cadr *args*) :direction :output)
        (princ (generate-header (all-content-path)) outs)
        (princ "<body><div>" outs)
        (dolist (path (all-content-path)) (
            princ (generate-entry-div path) outs
        ))
        (princ (generate-footer) outs)
)
