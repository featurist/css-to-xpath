all: compile test

compile:
	./node_modules/.bin/pogo -c ./src/*.pogo
	mv ./src/*.js ./js

test:
	./node_modules/.bin/mocha test/*spec.pogo

.PHONY: test