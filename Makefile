.DEFAULT_GOAL := check

SHELL := /bin/bash

include tools.mk
include funcs.mk

check:: check-corim check-corim-examples
check:: check-xcorim
check:: check-comid check-comid-examples

COMID_FRAGS := concise-mid-tag.cddl
COMID_FRAGS += comid-code-points.cddl
COMID_FRAGS += concise-swid-tag.cddl
COMID_FRAGS += common.cddl
COMID_FRAGS += generic-non-empty.cddl

COMID_EXAMPLES := $(wildcard examples/comid-*.diag)

$(eval $(call cddl_check_template,comid,$(COMID_FRAGS),$(COMID_EXAMPLES)))

CORIM_FRAGS := concise-rim.cddl
CORIM_FRAGS += signed-corim.cddl
CORIM_FRAGS += corim.cddl
CORIM_FRAGS += concise-mid-tag.cddl
CORIM_FRAGS += concise-swid-tag.cddl
CORIM_FRAGS += comid-code-points.cddl
CORIM_FRAGS += corim-code-points.cddl
CORIM_FRAGS += generic-non-empty.cddl
CORIM_FRAGS += common.cddl

CORIM_EXAMPLES := $(wildcard examples/corim-*.diag)

$(eval $(call cddl_check_template,corim,$(CORIM_FRAGS),$(CORIM_EXAMPLES)))

XCORIM_FRAGS += xcorim.cddl
XCORIM_FRAGS += xcorim-code-points.cddl
XCORIM_FRAGS += common.cddl

$(eval $(call cddl_check_template,xcorim,$(XCORIM_FRAGS),))

GITHUB := https://raw.githubusercontent.com/
COSWID_REPO := sacmwg/draft-ietf-sacm-coswid/master
COSWID_REPO_URL := $(join $(GITHUB), $(COSWID_REPO))

concise-swid-tag.cddl: ; $(curl) -O $(COSWID_REPO_URL)/$@

CLEANFILES += concise-swid-tag.cddl

clean: ; $(RM) $(CLEANFILES)

# Extract the CBOR tags defined by CoRIM/CoMID (i.e., those in the 5xx space)
cbor-tags.txt: $(wildcard *.cddl) ; grep -h '#6\.5' *cddl | sort -u -t'=' -k2 > $@
