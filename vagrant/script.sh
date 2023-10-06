sudo su
sudo mdadm --create --verbose /dev/md10 -l 10 -n 4 /dev/vdb /dev/vdc /dev/vdd /dev/vde
mdadm --detail --scan >> /etc/mdadm.conf 
mdadm /dev/md10 --fail /dev/vdb
mdadm /dev/md10 --remove /dev/vdb
mdadm /dev/md10 --add /dev/vdf
parted -s /dev/md10 mklabel gpt 
parted -s /dev/md10 mkpart primary ext4 0% 20% 
parted -s /dev/md10 mkpart primary ext4 20% 40% 
parted -s /dev/md10 mkpart primary ext4 40% 60% 
parted -s /dev/md10 mkpart primary ext4 60% 80% 
parted -s /dev/md10 mkpart primary ext4 80% 100% 
for i in $(seq 1 5); do mkfs.ext4 /dev/md10p$i; done 
mkdir -p /raid/part{1,2,3,4,5} 
for i in $(seq 1 5); do mount /dev/md10p$i /raid/part$i; done 
for i in $(seq 1 5); do echo "/dev/md10p$i /raid/part$i ext4 defaults 0 0" >> /etc/fstab; done