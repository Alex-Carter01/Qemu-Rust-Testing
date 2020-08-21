#!/bin/sh

# Default values
qemu_bin=qemu-system-x86_64
virtiofs_daemon_bin=virtiofsd
virtiofs_daemon_type=QEMU
cloudinit_img=
shared_folder=${PWD}
boot_img=

show_help () {
        echo "Usage: ${0} [OPTION] ... [BOOT_IMAGE]"
	echo "Start qemu with a folder shared through virtiofsd"
	echo "BOOT_IMAGE is mandatory and is the OS image to boot in the VM"
	echo "Options:"
	echo "\t-q\tPath to a qemu binary. Defaults to ${qemu_bin}"
	echo "\t-d\tPath to a virtiofs daemon binary. Defaults to ${virtiofs_daemon_bin}"
	echo "\t-c\tPath to a cloud-init image. If not provided, no cloud-init image will be used"
	echo "\t-s\tPath to the folder on the host to be shared. Defaults to ${shared_folder}"
	echo "\t-v\tType of virtio daemon to use. Can be either QEMU or CH (For Cloud-Hypervisor)"
}

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts "h?q:d:s:v:c:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    q)  qemu_bin=$OPTARG
	;;
    d)  virtiofs_daemon_bin=$OPTARG
	;;
    c)  cloudinit_img=$OPTARG
	;;
    v)  virtiofs_daemon_type=$OPTARG
	;;
    s)  shared_folder=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

if [ "$#" != "1" ]; then
	show_help
	exit 0
fi

boot_img=${1}

vhost_socket=$(mktemp)

case "${virtiofs_daemon_type}" in
	"QEMU")
		echo "Will use QEMU virtiofsd"
		${virtiofs_daemon_bin} -f -o cache=auto -o source=${shared_folder} --socket-path=${vhost_socket} &
		;;
	"CH")
		echo "Will use Cloud-Hypervisor virtiofsd"
		${virtiofs_daemon_bin} --socket ${vhost_socket} --shared-dir ${shared_folder} &
		;;
	*)
		echo "Unrecognized virtiofs daemon"
		exit 1
esac

qemu_cmdline="-enable-kvm \
	-drive file=${boot_img},media=disk,if=virtio \
	-nographic \
	-chardev socket,id=char0,path=${vhost_socket} \
	-device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs \
	-m 4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on -numa node,memdev=mem \
	-nic user,model=virtio-net-pci"

if [ "${cloudinit_img}" != "" ]; then
	qemu_cmdline+=" -drive file=${cloudinit_img},if=virtio"
fi
	${qemu_bin} ${qemu_cmdline}
