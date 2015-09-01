VAGRANTFILE_API_VERSION = "2"

base_dir = File.expand_path(File.dirname(__FILE__))
cluster = {
  "mesos-master1" => { :ip => "100.0.10.11",  :cpus => 1, :mem => 768 },
  "mesos-master2" => { :ip => "100.0.10.12",  :cpus => 1, :mem => 768 },
  "mesos-master3" => { :ip => "100.0.10.13",  :cpus => 1, :mem => 768 },
  "mesos-slave1"  => { :ip => "100.0.10.101", :cpus => 1, :mem => 512 },
  "mesos-slave2"  => { :ip => "100.0.10.102", :cpus => 1, :mem => 512 },
  "mesos-slave3"  => { :ip => "100.0.10.103", :cpus => 1, :mem => 512 },
  # "kafka-node1"   => { :ip => "100.0.20.101", :cpus => 1, :mem => 1536 },
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box #:machine
    config.cache.enable :apt 
    config.cache.enable :apt_cacher
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end # end if

  # manage /etc/hosts on boxes and host
  # ( requires vagrant-hostmanager plugin)
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.include_offline = true

  cluster.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |cfg|

      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.box = "trusty64"
        override.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname

        vb.name = 'vagrant-mesos-' + hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on" ]
      end # end cfg.vm.provider

      # provision nodes with ansible
      if index == cluster.size - 1
        cfg.vm.provision :ansible do |ansible|
          ansible.verbose = "v"

          ansible.inventory_path = "inventory/vagrant"
          ansible.playbook = "cluster.yml"
          ansible.limit = 'all'# "#{info[:ip]}" # Ansible hosts are identified by ip
        end # end cfg.vm.provision
      end #end if

    end # end config

  end #end cluster

end #end vagrant
