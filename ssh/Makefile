#                                                                                                                        
# Makefile for SSH Files
#

default: id_rsa id_rsa.pub authorized_keys


id_rsa id_rsa.pub:
	ssh-keygen -N "" -C "TechEx19 perfSONAR Ansible Account" -f id_rsa -q
TO_CLEAN += id_rsa id_rsa.pub


authorized_keys: ./user-keys
	find ./user-keys -type f -print \
	| xargs -r cat \
	> $@
TO_CLEAN += authorized_keys


clean:
	rm -rf $(TO_CLEAN) *~
