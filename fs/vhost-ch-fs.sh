rm /tmp/vhostqemu

/home/acarter/cloud-hypervisor/build/cargo_target/x86_64-unknown-linux-gnu/release/vhost_user_fs \
	--socket /tmp/vhostqemu \
	--shared-dir /tmp/test-ch
