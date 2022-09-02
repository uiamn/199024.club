CLISP = /usr/bin/clisp -m 1024MB
CONTENTS := $(shell ls content/???????? content/**/????????)

public/diary/index.html: generator.fas generator.lib $(CONTENTS)
	$(CLISP) $< content public/diary/

deploy: index.html style.css
	git add index.html content
	git commit -m "deploy"
	git push

generator.fas generator.lib: $(shell ls generator/*.lisp)
	$(CLISP) -c generator/main.lisp -o generator
