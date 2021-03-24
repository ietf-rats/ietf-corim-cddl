# cddl is a prerequisite
# fail hard if it is not found
cddl ?= $(shell command -v cddl)
ifeq ($(strip $(cddl)),)
$(error cddl not found. To install cddl: 'gem install cddl')
endif
