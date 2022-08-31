(load "generator/header-generator.lisp")
(load "generator/footer-generator.lisp")
(load "generator/body-generator.lisp")
(load "generator/content-paths-getter.lisp")

(defun generate-html (contents-paths) (
    concatenate 'string
        (generate-header contents-paths)
        "<body><div>"
        (reduce (lambda (acc path) (concatenate 'string acc (generate-entry-div path))) contents-paths :initial-value "")
        (generate-footer)
))

(defun write-html (html outdir filename) (
    with-open-file (outs (concatenate 'string outdir filename) :direction :output) (princ html outs)
))

(defun write-all-html (paths-separated-by-month outdir) (
    progn
        (write-html (generate-html (car paths-separated-by-month)) outdir "index.html")
        (mapcar (lambda (paths) (write-html (generate-html paths) outdir (concatenate 'string (get-year-month-str-from-path (car paths)) ".html"))) (cdr paths-separated-by-month))
))

(write-all-html (separete-by-month (all-content-path (car *args*))) (cadr *args*))
