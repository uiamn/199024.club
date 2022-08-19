CLISP = /usr/bin/clisp
THIS_MONTH_CONTENTS := $(shell ls content/????????)

index.html: generator.fas generator.lib $(THIS_MONTH_CONTENTS)
	clisp $< content index.html

deploy: index.html
	git add index.html content
	git commit -m "deploy"
	git push

generator.fas generator.lib: generator/main.lisp
	clisp -c $< -o generator
