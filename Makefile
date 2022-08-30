CLISP = /usr/bin/clisp
THIS_MONTH_CONTENTS := $(shell ls content/????????)

index.html: generator.fas generator.lib $(THIS_MONTH_CONTENTS)
	$(CLISP) $< content index.html

deploy: index.html style.css
	git add index.html content
	git commit -m "deploy"
	git push

generator.fas generator.lib: $(shell ls generator/*.lisp)
	$(CLISP) -c generator/main.lisp -o generator
