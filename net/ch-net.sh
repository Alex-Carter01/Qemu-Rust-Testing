rm /tmp/vhostqemu

/home/acarter/cloud-hypervisor/build/cargo_target/x86_64-unknown-linux-gnu/release/vhost_user_net \
	--net-backend ip=127.0.0.1,mask=255.0.0.0,socket=/tmp/vhostqemu,num_queues=1,queue_size=128 #,tap=
