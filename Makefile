# Build prerequisites
#
#   1. a sane GNU system
#   2. Node.js
#   3. the markdown-toc package (https://github.com/jonschlinkert/markdown-toc)

.PHONY: all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: README.md EXERCISES.md

README.md: Makefile manuscript/*.md manuscript/oracle/*.md manuscript/sqlserver/*.md manuscript/postgresql/*.md manuscript/mysql/*.md
	( cd manuscript && xargs cat < Book.txt ) | grep -v '^<!-- vim:' > README.md

EXERCISES.md: Makefile exercises/*.md exercises/oracle/*.md
	( cd exercises  && xargs cat < Book.txt ) | grep -v '^<!-- vim:' >  EXERCISES.md

clean:
	rm -f README.md EXERCISES.md
