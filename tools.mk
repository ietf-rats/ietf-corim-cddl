# assume the first entry of the path used to search for gems
# is found under the user's HOME dir
_gempath := $(shell gem env gempath | cut -d':' -f1)

cddl := $(join $(_gempath), /bin/cddl)

.PHONY: install-cddl
install-cddl:
	[ -x $(cddl) ] || gem install --user-install cddl

.PHONY: install-tools
install-tools: install-cddl
