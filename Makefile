CLISP = /usr/bin/clisp
THIS_MONTH_CONTENTS := $(shell ls content/????????)

index.html: generator.fas generator.lib $(THIS_MONTH_CONTENTS)
	clisp $< content index.html

generator.fas generator.lib: generator/main.lisp
	clisp -c $< -o generator
