#usr: root, pwd: root

/home/acarter/qemu-5.0.0/x86_64-softmmu/qemu-system-x86_64 \
 	-enable-kvm \
	-drive file=/tmp/focal-server-cloudimg-amd64-disk-kvm.img,media=disk,if=virtio \
       	-nographic \
	-drive file=/tmp/nocloud.img,if=virtio -m 4095 \
	-chardev socket,id=char0,path=/tmp/vhostqemu \
	-m 4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem \
#	-device vhost-user-blk-pci,queue-size=1024,chardev=char0
