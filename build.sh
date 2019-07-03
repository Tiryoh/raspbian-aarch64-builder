#!/usr/bin/env bash
set -eu

SRC_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

sudo apt update
sudo apt install -y build-essential libgmp-dev libmpfr-dev libmpc-dev libisl-dev libncurses5-dev bc git bison flex bc libssl-dev unzip gcc-aarch64-linux-gnu
mkdir -p $SRC_DIR/kernel
mkdir -p $SRC_DIR/Downloads
cd $SRC_DIR
[[ ! -e $SRC_DIR/linux ]] && git clone --depth=1 https://github.com/raspberrypi/linux
cd $SRC_DIR/linux
KERNEL=kernel7
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O=$SRC_DIR/kernel bcmrpi3_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O=$SRC_DIR/kernel Image modules dtbs -j8
cd $SRC_DIR/Downloads
# wget -c http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/images/raspbian-2019-06-24/2019-06-20-raspbian-buster.zip.sha256
# wget -c http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/images/raspbian-2019-06-24/2019-06-20-raspbian-buster.zip
# sha256sum -c 2019-06-20-raspbian-buster.zip.sha256
# unzip 2019-06-20-raspbian-buster.zip
wget -c http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/images/raspbian-2019-04-09/2019-04-08-raspbian-stretch.zip.sha256
wget -c http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/images/raspbian-2019-04-09/2019-04-08-raspbian-stretch.zip
sha256sum -c 2019-04-08-raspbian-stretch.zip.sha256
unzip 2019-04-08-raspbian-stretch.zip
