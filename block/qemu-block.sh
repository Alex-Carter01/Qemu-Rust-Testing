#todo: path

/home/acarter/qemu-5.0.0/x86_64-softmmu/qemu-system-x86_64 \
 	-enable-kvm \
       	-nographic \
	-chardev socket,id=char0,path=/tmp/vhostqemu \
	-m 4G \
	-object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem \
	-device vhost-user-blk-pci,queue-size=128,chardev=char0
