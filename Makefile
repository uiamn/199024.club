CLISP = /usr/bin/clisp
THIS_MONTH_CONTENTS := $(shell ls content/????????)

index.html: generator.fas generator.lib $(THIS_MONTH_CONTENTS) style.css
	$(CLISP) $< content index.html

deploy: index.html
	git add index.html content
	git commit -m "deploy"
	git push

generator.fas generator.lib: generator/main.lisp
	$(CLISP) -c $< -o generator
