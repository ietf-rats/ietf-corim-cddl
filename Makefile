.DEFAULT_GOAL := check

SHELL := /bin/bash

include tools.mk

%.cbor: %.diag
	$(diag2cbor) $< > $@

check:: check-corim check-corim-examples
check:: check-xcorim
check:: check-comid check-comid-examples

# $1: label
# $2: cddl fragments
# $3: diag test files
define cddl_check_template

check-$(1): $(1)-autogen.cddl
	$$(cddl) $$< g 1 | $$(diag2diag) -e

.PHONY: check-$(1)

$(1)-autogen.cddl: $(2)
	for f in $$^ ; do ( grep -v '^;' $$$$f ; echo ) ; done > $$@

CLEANFILES += $(1)-autogen.cddl

check-$(1)-examples: $(1)-autogen.cddl $(3:.diag=.cbor)
	@for f in $(3:.diag=.cbor); do \
		echo ">> validating $$$$f against $$<" ; \
		$$(cddl) $$< validate $$$$f &>/dev/null || exit 1 ; \
		echo ">> saving prettified CBOR to $$$${f%.cbor}.pretty" ; \
		$$(cbor2pretty) $$$$f > $$$${f%.cbor}.pretty ; \
	done

.PHONY: check-$(1)-examples

CLEANFILES += $(3:.diag=.cbor)
CLEANFILES += $(3:.diag=.pretty)

endef # cddl_check_template

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
