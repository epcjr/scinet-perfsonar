# SCinet perfSONAR Deployment Workbench

This project contains infrastructure for running a mockup of the
SCinet perfSONAR deployment on VMs.

More to come...



## SCinet Setup

On each perfSONAR host (controller, publisher, archive, dashboard and
testpoints), install a minimal CentOS 7.  Do not take any other steps
to secure the machine.

Log onto the controller as `root` and do the following:

 * `yum -y install git`
 * `git clone https://github.com/mfeit-internet2/scinet-perfsonar`  (TODO: Change this)
 * `cd scinet-perfsonar`
 * TODO:  Edit ansible inventory in `ansible/inentory-scinet`
 * Populate `mesh/booth-mesh/booths-scinet/scinet-booths.csv` and
``mesh/booth-mesh/booths-scinet/scinet-vlans.csv` with data from the
intranet.  Note that this currently requires some hand massaging.
That will be remedied.
 * `make phase1`


Still on the controller, repeat the following for each of the
non-controller hosts:

 * `scp build-ansible-account ssh/id_rsa.pub root@HOST-NAME`
 * `ssh root@HOST-NAME -c "sh ./build-ansible-account id_rsa.pub"`


Still on the controller:

 * Run `make phase2`.



## Development (Vagrant VM) Setup

 * Edit the `hosts` and `gateway variables in the `Vagrantfile` to run
   on VMs.  Note that the VMs' network configurations are specific to
   Internet2's perfSONAR development farm and will likely be different
   on your system.

 * `make vagrant`

 * Add SSH public key to the `ssh/user-keys` directory, one per file.
   All of these will be authorized to log into the ansible account.

 * Update the list of DNOCs in `mesh/booth-mesh/dnocs.json` for the
   current year's NOC and DNOCs.

 * Populate `mesh/booth-mesh/booths-scinet/scinet-booths.csv` and
``mesh/booth-mesh/booths-scinet/scinet-vlans.csv` with data from the
intranet.  Note that this currently requires some hand massaging.
That will be remedied.

