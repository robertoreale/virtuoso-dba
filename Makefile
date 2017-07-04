.PHONY: README.md all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: README.md

README.md: manuscript/*.md
	cat manuscript/cover.md manuscript/chapter??.md | grep -v '^<!-- vim:' > README.md

clean:
	rm -f README.md
