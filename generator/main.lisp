(load "generator/header-generator.lisp")
(load "generator/footer-generator.lisp")
(load "generator/body-generator.lisp")

(defun all-content-path () (
    sort (directory (concatenate 'string (car *args*) "/**/????????")) #'string> :key #'pathname-name
))

(defun generate-html (contents-paths out-path) (
    with-open-file
        (outs out-path :direction :output)
        (princ (generate-header contents-paths) outs)
        (princ "<body><div>" outs)
        (dolist (path (all-content-path)) (
            princ (generate-entry-div path) outs
        ))
        (princ (generate-footer) outs)
))

(
    generate-html (all-content-path) (concatenate 'string (cadr *args*) "index.html")
)
