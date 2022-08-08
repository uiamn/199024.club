(defun all-content-path () (
    sort (directory "../content/**/????????") #'string> :key #'pathname-name
))

(defun count-top-spaces (line n) (
    if (eq (car line) #\Space)
        (count-top-spaces (cdr line) (1+ n))
        n
))

(defun top-spaces-trim (line) (string-left-trim '(#\Space) line))


(defun generate-line-sub (line top-spaces) (
    if (eq top-spaces 0)
        (concatenate 'string "<h3>" (top-spaces-trim line) "</h3><div>")
        (concatenate 'string "<li>" (top-spaces-trim line) "</li>")
))

(defun generate-line-sub-indent (line top-spaces) (
    concatenate 'string "<ul><li>" (top-spaces-trim line) "</li>"
))

(defun generate-end-ul (top-spaces top-spaces-stack) (
    if (eq top-spaces (car top-spaces-stack))
        ""
        (progn
            (pop top-spaces-stack)
            (concatenate 'string "</ul>" (generate-end-ul top-spaces top-spaces-stack))
        )
))

(defun generate-line-sub-dedent (line top-spaces top-spaces-stack) (
    progn
        (pop top-spaces-stack)
        (concatenate 'string
            (generate-end-ul top-spaces top-spaces-stack)
            (generate-line-sub line top-spaces)
        )
))

(defun generate-line (line top-spaces-stack) (
    if (string= line "")
        ""
        (let ((top-spaces (count-top-spaces (coerce line 'list) 0)))
            (cond
                ((eq top-spaces (car top-spaces-stack)) (generate-line-sub line top-spaces))
                ((> top-spaces (car top-spaces-stack)) (generate-line-sub-indent line top-spaces))
                (t generate-sub-dedent line top-spaces top-spaces-stack)
            )
        )
))

;; (defun next-top-spaces-stack (top-spaces ))

(defun generate-entry-div (entry-path) (
    with-open-file (f entry-path :direction :input) (
        let (
            (lines '("<div class=\"entry\">ひづけ"))
            (top-spaces-stack '(0))
        )
            (loop for line = (read-line f nil) while line do
                (nconc lines (list (generate-line line top-spaces-stack)))
            )
            (nconc lines (list (generate-end-ul 0 top-spaces-stack)))
    )
))

(
    print (generate-entry-div (car (all-content-path)))
    ;; let ((r '(a b c d)))
    ;;     (print (pop r))
    ;;     (print (push 'x r))
    ;;     (print r)
    ;; let ((nums '(3 2 1)))
    ;;     (loop for i from 0
    ;;         while (< i 10)
    ;;         do
    ;;             (nconc nums (list i))
    ;;             (print nums)
    ;;     )
)
