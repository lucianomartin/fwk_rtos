#!/bin/sh

./create_fs.sh
xflash --quad-spi-clock 50MHz --factory ../bin/iot_aws.xe --boot-partition-size 0x100000 --data ./fat.fs
