(defun basic-elements ()
    "
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
    "
)


(defun generate-header () (
    let ((header "<!DOCTYPE html><html><head>"))
        (setq header (concatenate 'string header (basic-elements)))
        (setq header (concatenate 'string header "</head>"))
        header
))
