(load "reviser.lisp")

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
        "</ul>"
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
            (if (eq top-spaces 0)
                (concatenate 'string "</div><h3>" (top-spaces-trim line) "</h3><div>")
                (concatenate 'string "<li>" (top-spaces-trim line) "</li>")
            )
        )
))

(defun generate-line (line top-spaces top-spaces-stack) (
    if (string= line "")
        ""
        (cond
            ((eq top-spaces (car top-spaces-stack)) (generate-line-sub line top-spaces))
            ((> top-spaces (car top-spaces-stack)) (generate-line-sub-indent line top-spaces))
            (t (generate-line-sub-dedent line top-spaces top-spaces-stack))
        )

))

(defun next-top-spaces-stack (top-spaces top-spaces-stack) (
    cond
        ((eq top-spaces (car top-spaces-stack)) top-spaces-stack)
        ((> top-spaces (car top-spaces-stack)) (cons top-spaces top-spaces-stack))
        (t (next-top-spaces-stack top-spaces (cdr top-spaces-stack)))
))

(defun path-to-date (entry-path) (
    let ((filename (file-namestring entry-path))) (
        concatenate 'string
            (subseq filename 0 4)
            " 年 "
            (
                let ((c (aref filename 4))) (
                    if (eq c #\0) "" "1"
                )
            )
            (string (aref filename 5))
            " 月 "
            (
                let ((c (aref filename 6))) (
                    if (eq c #\0) "" "1"
                )
            )
            (string (aref filename 7))
            " 日"
    )
))

(defun generate-entry-div (entry-path) (
    with-open-file (f entry-path :direction :input) (
        let (
            (lines (list (concatenate 'string "<div class=\"entry\"><h2>■ " (path-to-date entry-path) "</h2>")))
            (top-spaces-stack '(0))
            (top-spaces nil)
        )
            (loop for line = (read-line f nil) while line do
                (if (string= line "")
                    ()
                    (progn
                        (setq line (revise line))
                        (setq top-spaces (count-top-spaces (coerce line 'list) 0))
                        (nconc lines (list (generate-line line top-spaces top-spaces-stack)))
                        (setq top-spaces-stack (next-top-spaces-stack top-spaces top-spaces-stack))
                    )
                )
            )
            (nconc lines (list (generate-end-ul 0 top-spaces-stack) "</div></div>"))
    )
))

(defun write-header (out-stream) (
    princ
    "
        <!DOCTYPE html><html>
        <head>
            <meta charset=\"utf-8\">
            <meta property=\"og:site_name\" content=\"日記\" />
            <meta property=\"og:description\" content=\"日記\" />
            <meta property=\"og:image\" content=\"https://diary.199024.club/test.jpg\" />
            <meta property=\"og:title\" content=\"日記\"/>
            <meta property=\"twitter:card\" content=\"summary\" />
            <meta property=\"twitter:image\" content=\"https://diary.199024.club/test.jpg\" />
            <link rel=\"icon\" href=\"https://diary.199024.club/test.jpg\">
            <title>日記</title>
            <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">
        </head>
        <body>
            <div>
    "
    out-stream
))

(defun write-footer (out-stream) (
    princ "</div></body></html>" out-stream
))

(
    with-open-file
        (outs "index.html" :direction :output)
        (write-header outs)
        (dolist (path (all-content-path)) (
            dolist (line (generate-entry-div path)) (
                princ line outs
            )
        ))
        (write-footer outs)
)
