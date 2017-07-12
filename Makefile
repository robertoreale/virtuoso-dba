# Build prerequisites
#
#   1. a sane GNU system
#   2. Node.js
#   3. the markdown-toc package (https://github.com/jonschlinkert/markdown-toc)

.PHONY: README.md all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: README.md

README.md: manuscript/*.md markdown/*.md
	( cd markdown   && xargs cat < Book.txt ) | grep -v '^<!-- vim:' >  README.md
	( cd manuscript && xargs cat < Book.txt ) | grep -v '^<!-- vim:' >> README.md
	markdown-toc -i README.md

clean:
	rm -f README.md
