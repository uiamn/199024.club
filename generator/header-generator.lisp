(defun basic-elements ()
    "
        <meta charset=\"utf-8\">
        <meta property=\"og:site_name\" content=\"日記\" />
        <meta property=\"og:description\" content=\"日記\" />
        <meta property=\"og:image\" content=\"https://199024.club/test.jpg\" />
        <meta property=\"og:title\" content=\"日記\"/>
        <meta property=\"twitter:card\" content=\"summary\" />
        <meta property=\"twitter:image\" content=\"https://199024.club/test.jpg\" />
        <link rel=\"icon\" href=\"https://199024.club/test.jpg\">
        <title>日記</title>
        <link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">
    "
)

(defun zero-trim-str (n) (
    if (>= n 10)
        (princ-to-string n)
        (concatenate 'string "0" (princ-to-string n))
))

(defun link-in-page (entries-paths) (
    if (null entries-paths)
        ""
        (concatenate 'string
            (link-in-page (cdr entries-paths))
            "<a href=\"#day"
            (subseq (file-namestring (car entries-paths)) 6 8)
            "\">"
            (string-left-trim '(#\0) (subseq (file-namestring (car entries-paths)) 6 8))
            "</a> "
        )
))


(defun generate-header (entries-paths) (
    let ((header "<!DOCTYPE html><html><head>"))
        (setq header (concatenate 'string header (basic-elements)))
        (setq header (concatenate 'string header (link-in-page entries-paths)))
        (setq header (concatenate 'string header "</head>"))
        header
))
