# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "debian/jessie64" #Debian 8

  #bridge network
  config.vm.network "public_network"


#here's where the magic happen
# Creation de trois hd de 10go dynamique en raidz pour tester et attachement de ceux-ci 
  config.vm.provider "virtualbox" do |vb|

    sdb = './hd/sdb.vdi'  
    sdc = './hd/sdc.vdi'  
    sdd = './hd/sdd.vdi'  

    hdDirectory = 'hd'
    hdSize = 10

    #creation du dossier si il nexiste pas

    if not Dir.exists?(hdDirectory)
      Dir.mkdir(hdDirectory)
    end

    if not File.exists?(sdb)  
        #le lien pour la documentation 
        #https://www.virtualbox.org/manual/ch08.html#vboxmanage-createvdi
        vb.customize ['createhd', '--filename', sdb, '--variant', 'Standard', '--size', hdSize*1024]
    end  


    if not File.exists?(sdc)  
        vb.customize ['createhd', '--filename', sdc, '--variant', 'Standard', '--size', hdSize*1024]
    end  

    if not File.exists?(sdd)  
        vb.customize ['createhd', '--filename', sdd, '--variant', 'Standard', '--size', hdSize*1024]

        

        # Attaching the disks using the default SATA controller via the filepath
        # https://www.virtualbox.org/manual/ch08.html#vboxmanage-storageattach
        vb.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', sdb]
        vb.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', sdc]
        vb.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', sdd]
    end  
  end

  #ansible seting up zfs volume for us
  #creating a pool with lz4 compression and deduplication enabled
  #pool name is going to be /lxcstorage
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbook.yml"
  end
end
