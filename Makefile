CLISP = /usr/bin/clisp -m 1024MB
THIS_MONTH_CONTENTS := $(shell ls content/????????)
OLD_CONTENTS := $(shell ls content/**/????????)

public/diary/index.html: generator.fas generator.lib $(THIS_MONTH_CONTENTS)
	$(CLISP) $< content public/diary/

deploy: index.html style.css
	git add index.html content
	git commit -m "deploy"
	git push

generator.fas generator.lib: $(shell ls generator/*.lisp)
	$(CLISP) -c generator/main.lisp -o generator
