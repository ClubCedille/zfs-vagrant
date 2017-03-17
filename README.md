# ZFS installation sur debian jessie avec Ansible

## configuration

le script ansible est supposé de créer un pool zfs raidz sur les trois disques dur générés par vagrant.
Les pool devraient être compressé et dedupliqué
Ensuite, le script doit changer le dossier pour stocker les containeurs lxc vers le pool zfs.
Pour tester le script va créer 2 conteneurs de Débian pour voir si la compression et la déduplication fonctionnent

## prérequis sur la machine hôte

- vagrant 
- ansible 2.2

## Pour démarer le setup 

Dans le dossier du projet, exécuter `vagrant up`

## Vagrant

Voici comment les disques dur sont générés (les disques dur sont stockés dans ./hd)
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
Réseau NAT

## Configuration après installation
### ZFS

```
root@jessie:~# zfs list
NAME           USED  AVAIL  REFER  MOUNTPOINT
zfs-pool      99.9K  19.2G  24.0K  /zfs-pool
zfs-pool/lxd  24.0K  19.2G  24.0K  /zfs-pool/lxd
------------------------------------------------
root@jessie:~# zpool list
NAME       SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
zfs-pool  29.8G   198K  29.7G         -     0%     0%  1.00x  ONLINE  -
------------------------------------------------
root@jessie:~# zfs get compression 
NAME          PROPERTY     VALUE     SOURCE
zfs-pool      compression  off       default
zfs-pool/lxd  compression  on        local
------------------------------------------------
root@jessie:~# zfs get dedup
NAME          PROPERTY  VALUE          SOURCE
zfs-pool      dedup     on             local
zfs-pool/lxd  dedup     on             local
```
### LXC Après installation
```
root@jessie:~# zpool list
NAME       SIZE  ALLOC   FREE  EXPANDSZ   FRAG    CAP  DEDUP  HEALTH  ALTROOT
zfs-pool  29.8G   260M  29.5G         -     0%     0%  2.03x  ONLINE  -
root@jessie:~# zfs list
NAME           USED  AVAIL  REFER  MOUNTPOINT
zfs-pool       341M  19.0G  24.0K  /zfs-pool
zfs-pool/lxc   336M  19.0G   336M  /zfs-pool/lxc
root@jessie:~# zfs get compressratio 
NAME          PROPERTY       VALUE  SOURCE
zfs-pool      compressratio  1.75x  -
zfs-pool/lxc  compressratio  1.75x  -

```
Ici on peut voir que les fichiers des conteneurs sont compressé et qu'il sont dédupliqué.

