# raspbian-aarch64-builder

基本的には以下のページに沿って進める。

Raspbianのカーネルを64bitにする - Qiita  
https://qiita.com/Hiroki_Kawakami/items/6ab4ecc184c368e438f4

## 手順

ビルド

```sh
./build.sh
```

インストール

`loop2`のところは使用する環境によっては変わる場合がある。

```sh
sudo kpartx -a $SRC_DIR/Downloads/2019-06-20-raspbian-buster.img
mkdir -p $SRC_DIR/mnt/fat32
mkdir -p $SRC_DIR/mnt/ext4
sudo mount -t vfat /dev/mapper/loop2p1 $SRC_DIR/mnt/fat32
sudo mount -t ext4 /dev/mapper/loop2p2 $SRC_DIR/mnt/ext4
cd $SRC_DIR/linux
sudo make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O=$SRC_DIR/kernel INSTALL_MOD_PATH=$SRC_DIR/mnt/ext4 modules_install
sudo cp $SRC_DIR/kernel/arch/arm64/boot/Image $SRC_DIR/mnt/fat32/
sudo cp $SRC_DIR/kernel/arch/arm64/boot/dts/broadcom/*.dtb $SRC_DIR/mnt/fat32/
sudo cp $SRC_DIR/kernel/arch/arm64/boot/dts/overlays/*.dtb* $SRC_DIR/mnt/fat32/overlays/
echo kernel=Image | sudo tee -a $SRC_DIR/mnt/fat32/config.txt
echo arm_control=0x200 | sudo tee -a $SRC_DIR/mnt/fat32/config.txt
sudo umount $SRC_DIR/mnt/fat32
sudo umount $SRC_DIR/mnt/ext4
sudo kpartx -d /dev/loop2
sudo losetup -d /dev/loop2
cd $SRC_DIR/Downloads
xz -kvz 2019-06-20-raspbian-buster.img
```
