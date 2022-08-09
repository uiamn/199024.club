(defun replace-pronunciation-sub (char) (
    cond
        ((eq char #\HIRAGANA_LETTER_SMALL_TU) #\HIRAGANA_LETTER_TU)
        ((eq char #\HIRAGANA_LETTER_SMALL_YA) #\HIRAGANA_LETTER_YA)
        ((eq char #\HIRAGANA_LETTER_SMALL_YU) #\HIRAGANA_LETTER_YU)
        ((eq char #\HIRAGANA_LETTER_SMALL_YO) #\HIRAGANA_LETTER_YO)
        ((eq char #\HIRAGANA_LETTER_SMALL_A) #\HIRAGANA_LETTER_A)
        ((eq char #\HIRAGANA_LETTER_SMALL_I) #\HIRAGANA_LETTER_I)
        ((eq char #\HIRAGANA_LETTER_SMALL_U) #\HIRAGANA_LETTER_U)
        ((eq char #\HIRAGANA_LETTER_SMALL_E) #\HIRAGANA_LETTER_E)
        ((eq char #\HIRAGANA_LETTER_SMALL_O) #\HIRAGANA_LETTER_O)
        (t char)
))

(defun replace-pronunciation (line) (
    map 'string 'replace-pronunciation-sub line
))

(defun revise (line) (
    let ((revised line))
        (setq revised (replace-pronunciation revised))
        revised
))
