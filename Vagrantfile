#
# SC19 perfSONAR Deployment Test Boxes
#


hosts = [

      [ "publisher", "10.10.1.1", 8081 ],
      [ "archive",   "10.10.1.2", 8082 ],
      [ "maddash",   "10.10.1.3", 8083 ],
      [ "testpoint", "10.10.1.4", 8084 ],
      [ "toolkit",   "10.10.1.5", 8085 ],
      [ "pwa",       "10.10.1.6", 8086 ],

      # This is built last so it can provision the others
      [ "controller","10.10.1.10", 8090 ]
]

etc_hosts = hosts.map { |host, ip| "#{ip} #{host}" }.join("\n")


Vagrant.configure("2") do |config|

  # The default E1000 has a security vulerability.
  config.vm.provider "virtualbox" do |vbox|
    vbox.default_nic_type = "82543GC"
  end

  hosts.each do |name, ip, forward|

    config.vm.define name do |host|

      host.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = 4096
        # Don't need the guest extensions on this host.
        if Vagrant.has_plugin?("vagrant-vbguest")
          config.vbguest.auto_update = false
        end
      end

      host.vm.box = "centos/7"
      host.vm.hostname = name

      host.vm.network "private_network", ip: ip,
        virtualbox__intnet: "perfsonar"

      host.vm.network "forwarded_port", guest: 80, host: forward

      # Fill the hosts file
      host.vm.provision "#{name}-hosts", type: "shell", run: "always", inline: <<-SHELL
        set -e

        fgrep localhost /etc/hosts > /etc/hosts.build
        echo "#{etc_hosts}" >> /etc/hosts.build
	mv -f /etc/hosts.build /etc/hosts
      SHELL

      # Account and system setup
      host.vm.provision "#{name}-ansible-user", type: "shell", run: "always", inline: <<-SHELL

        set -e

        cd /vagrant
	./build-ansible-account ./ssh/id_rsa.pub

      SHELL

 
      # Controller-only setup
      if name == "controller"

        host.vm.provision "ansible-controller", type: "shell", run: "always", inline: <<-SHELL

	  set -e

	  cd /vagrant
	  ./provision-controller

        SHELL

      end  # If controller

    end  # Config

  end  # hosts.each

end
