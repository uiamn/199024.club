CLISP = /usr/bin/clisp

all: generator.fas generator.lib
	clisp generator.fas content index.html

generator.fas generator.lib: generator/main.lisp
	clisp -c generator/main.lisp -o generator
