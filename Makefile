.DEFAULT_GOAL := check

SHELL := /bin/bash

include tools.mk

check: corim.cddl ; $(cddl) $< g 1

CLEANFILES += corim.cddl

CDDL_FRAGS := concise-rim.cddl
CDDL_FRAGS += signed-corim.cddl
CDDL_FRAGS += unsigned-corim.cddl
CDDL_FRAGS += concise-mid-tag.cddl
CDDL_FRAGS += concise-swid-tag.cddl
CDDL_FRAGS += concise-swid-tag-ext.cddl
CDDL_FRAGS += comid-code-points.cddl
CDDL_FRAGS += corim-code-points.cddl
CDDL_FRAGS += xcorim-code-points.cddl
CDDL_FRAGS += cose-key.cddl

corim.cddl: $(CDDL_FRAGS)
	for f in $^ ; do ( grep -v '^;' $$f ; echo ) ; done > $@

GITHUB := https://raw.githubusercontent.com/
COSWID_REPO := sacmwg/draft-ietf-sacm-coswid/master
COSWID_REPO_URL := $(join $(GITHUB), $(COSWID_REPO))

concise-swid-tag.cddl: ; $(curl) -O $(COSWID_REPO_URL)/$@

CLEANFILES += concise-swid-tag.cddl

clean: ; $(RM) $(CLEANFILES)
