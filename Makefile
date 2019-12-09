#                                                                                                                        
# Makefile for SC pS Environment
#


default:
	@echo "Please specify target phase1, phase2 or vagrant."


SUBDIRS=\
	ansible \
	ssh

subdirs:
	set -e ; \
	for DIR in $(SUBDIRS) ; \
	do \
		$(MAKE) -C $$DIR ; \
	done

# Pre-build of SSH keys for manual parts
phase1:
	rpm -q epel-release > /dev/null || yum -y install epel-release
	rpm -q jq > /dev/null || yum -y install jq
	rpm -q python-ipaddress > /dev/null || yum -y install python-ipaddress
	yum -y install jq python-ipaddress
	$(MAKE) subdirs
	./build-ansible-account ssh/authorized_keys


# Go forth and provision everything
phase2:
	./provision-controller



#
# These targets are for vagrant
#

VAGRANT_FLAG=.vagrant


vagrant: subdirs
	vagrant up


provision: subdirs id_rsa
	vagrant up --provision


ifndef SSH
  SSH=ansible
endif
login:
	[ -e "$(VAGRANT_FLAG)" ] && vagrant ssh "$(SSH)" -c "sudo -i"


destroy:
	-if [ -e "$(VAGRANT_FLAG)" ] ; \
	then \
		vagrant destroy -f ; \
	fi

rebuild: destroy vagrant


clean-only:
	set -e ; \
	for DIR in $(SUBDIRS) ; \
	do \
		$(MAKE) -C $$DIR clean ; \
	done
	rm -rf $(TO_CLEAN) *~

clean: destroy clean-only
