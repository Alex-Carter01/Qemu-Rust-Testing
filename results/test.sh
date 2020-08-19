fio fio_jobfile.fio --fallocate=none --runtime=30 --directory=/mnt --output-format=json+ --blocksize=65536 --output=results-{DEVICE_TYPE}-{qemu|ch}.json
