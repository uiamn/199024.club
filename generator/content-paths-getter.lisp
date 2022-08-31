(defun all-content-path (content-dir) (
    ;; get paths for all entries under the content directory or its sub-directories
    directory (concatenate 'string content-dir "/**/????????")
))

(defun get-year-month-str-from-path (path) (
    subseq (file-namestring path) 0 6
))

(defun separate-by-month-sub (contents-paths yearmonth tmp) (
    cond
        ((null contents-paths) (cons tmp nil))
        ((string= (get-year-month-str-from-path (car contents-paths)) yearmonth) (separate-by-month-sub (cdr contents-paths) yearmonth (append tmp (list (car contents-paths)))))
        (t (cons tmp (separate-by-month-sub (cdr contents-paths) (get-year-month-str-from-path (car contents-paths)) (list (car contents-paths)))))
))

(defun separete-by-month (contents-paths) (
    ;; separate entry paths by month
    separate-by-month-sub (sort contents-paths #'string> :key #'pathname-name) (get-year-month-str-from-path (car contents-paths)) nil
))
