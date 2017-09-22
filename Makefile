#    Copyright 2017 Red Hat Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

SHELL := /bin/bash

RPMBUILD = rpmbuild
PACKAGE_TARNAME = ovirt-cockpit-sso
PACKAGE_VERSION = 0.0.1
TGZ = $(PACKAGE_TARNAME)-$(PACKAGE_VERSION).tar.gz

TMPREPOS = tmp.repos
RPMBUILD_ARGS :=
RPMBUILD_ARGS += --define="_topdir `pwd`/$(TMPREPOS)"
RPMBUILD_ARGS += $(if $(RELEASE_SUFFIX), --define="release_suffix $$RELEASE_SUFFIX")

SOURCES = \
	container/cockpit-auth-ovirt \
	container/config/cockpit/cockpit.conf \
	ovirt-cockpit-sso.spec \
	LICENSE \
	README.md

DISTCLEANDIRS = \
	$(TMPREPOS) \
  $(TGZ)

dist: $(SOURCES)
	tar -czf "$(TGZ)" $^

srpm: dist
	rm -fr "$(TMPREPOS)"
	mkdir -p $(TMPREPOS)/{SPECS,RPMS,SRPMS,SOURCES}
	$(RPMBUILD) $(RPMBUILD_ARGS) -ts "$(TGZ)"
	@echo
	@echo "srpm available at '$(TMPREPOS)'"
	@echo

rpm:  srpm
	$(RPMBUILD) $(RPMBUILD_ARGS) --rebuild "$(TMPREPOS)"/SRPMS/*.src.rpm
	@echo
	@echo "rpm(s) available at '$(TMPREPOS)'"
	@echo


distclean: $(DISTCLEANDIRS)
	rm -rf $^

# vim: ts=2