# ZFS installation sur debian jessie avec Ansible

## configuration

le script ansible est supposé de créer un pool zfs raidz sur les trois disques dur générés par vagrant.
le derait être compressé et dedupliqué

## prérequis sur la machine hôte

- vagrant 
- ansible 2.2

## pour démarer le setup 

Dans le dossier du projet, exécuter `vagrant up`

## Vagrant

Voici comment les disques dur sont généré (les disques dur sont stockés dans ./hd)
```
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
```

## Réseau

la machine virtuelle est configurée en bridge
