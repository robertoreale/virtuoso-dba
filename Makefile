# Build prerequisites
#
#   1. a sane GNU system
#   2. Node.js
#   3. the markdown-toc package (https://github.com/jonschlinkert/markdown-toc)

.PHONY: all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: README.md EXERCISES.md

README.md: Makefile manuscript/*.md manuscript/oracle/*.md markdown/*.md
	( cd markdown   && xargs cat < Book.txt ) | grep -v '^<!-- vim:' >  README.md
	( cd manuscript && xargs cat < Book.txt ) | grep -v '^<!-- vim:' >> README.md
	markdown-toc -i README.md

EXERCISES.md: Makefile exercises/*.md exercises/oracle/*.md
	( cd exercises  && xargs cat < Book.txt ) | grep -v '^<!-- vim:' >  EXERCISES.md
	markdown-toc -i EXERCISES.md

clean:
	rm -f README.md EXERCISES.md
