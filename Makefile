.DEFAULT_GOAL := check

SHELL := /bin/bash

%.cbor: %.diag ; diag2cbor.rb $< > $@

include tools.mk

check:: check-corim check-xcorim
check:: check-comid check-comid-examples

# $1: label
# $2: cddl fragments
# $3: cbor test files
define cddl_check_template

check-$(1): $(1)-autogen.cddl
	$$(cddl) $$< g 1 | $$(diag2diag) -e

.PHONY: check-$(1)

$(1)-autogen.cddl: $(2)
	for f in $$^ ; do ( grep -v '^;' $$$$f ; echo ) ; done > $$@

check-$(1)-examples: $(1)-autogen.cddl $(3)
	@for f in $(3); do \
		echo ">> validating $$$$f" ; \
		$$(cddl) $$< validate $$$$f ; \
	done

CLEANFILES += $(1)-autogen.cddl

# TODO(tho) cleanup cbor files

endef # cddl_check_template

COMID_FRAGS := concise-mid-tag.cddl
COMID_FRAGS += comid-code-points.cddl
COMID_FRAGS += concise-swid-tag.cddl
COMID_FRAGS += common.cddl
COMID_FRAGS += generic-non-empty.cddl
COMID_FRAGS += cose-key.cddl

COMID_EXAMPLES := $(wildcard examples/comid-*.cbor)

$(eval $(call cddl_check_template,comid,$(COMID_FRAGS),$(COMID_EXAMPLES)))

CORIM_FRAGS := concise-rim.cddl
CORIM_FRAGS += signed-corim.cddl
CORIM_FRAGS += unsigned-corim.cddl
CORIM_FRAGS += concise-mid-tag.cddl
CORIM_FRAGS += concise-swid-tag.cddl
CORIM_FRAGS += comid-code-points.cddl
CORIM_FRAGS += corim-code-points.cddl
CORIM_FRAGS += generic-non-empty.cddl
CORIM_FRAGS += cose-key.cddl
CORIM_FRAGS += common.cddl

$(eval $(call cddl_check_template,corim,$(CORIM_FRAGS),))

XCORIM_FRAGS += xcorim.cddl
XCORIM_FRAGS += xcorim-code-points.cddl
XCORIM_FRAGS += common.cddl
XCORIM_FRAGS += generic-one-or-more.cddl

$(eval $(call cddl_check_template,xcorim,$(XCORIM_FRAGS),))

GITHUB := https://raw.githubusercontent.com/
COSWID_REPO := sacmwg/draft-ietf-sacm-coswid/master
COSWID_REPO_URL := $(join $(GITHUB), $(COSWID_REPO))

concise-swid-tag.cddl: ; $(curl) -O $(COSWID_REPO_URL)/$@

CLEANFILES += concise-swid-tag.cddl

clean: ; $(RM) $(CLEANFILES)
