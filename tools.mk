# cddl and curl are prerequisite
# fail hard if they are not found

cddl ?= $(shell command -v cddl)
ifeq ($(strip $(cddl)),)
$(error cddl not found. To install cddl: 'gem install cddl')
endif

curl ?= $(shell command -v curl)
ifeq ($(strip $(curl)),)
$(error curl not found)
endif
