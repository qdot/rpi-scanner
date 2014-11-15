#!/bin/bash
FILENAME=imagenum.txt
OUTPUTNAME=image
OUTPUTEXT=.jpg
IMGDIR=~/bee-images
SCANCMD="scanimage --format=tiff --mode=Color --resolution=600"

if [ ! -e $FILENAME ]; then
   echo 0 > $FILENAME
fi
declare -i NUM
NUM=`cat $FILENAME`
NEWNUM=$(( NUM+1 ))
echo "Image Number: $NEWNUM"
echo $NEWNUM > $FILENAME
IMGNAME=`printf %s%05d%s $OUTPUTNAME $NEWNUM $OUTPUTEXT`

if [ ! -e $IMGDIR ]; then
    mkdir $IMGDIR
fi

if [ ! -e /dev/sda1 ]; then
    echo "Cannot find USB drive. Exiting."
    exit 1
fi

if ! mountpoint -q $IMGDIR; then
    sudo mount -t vfat -o rw,uid=1000,gid=1000 /dev/sda1 $IMGDIR
fi


if [ -e $IMGDIR/scancmd.txt ]; then
    SCANCMD=`cat $IMGDIR/scancmd.txt`
fi
SCANCMD="sudo env $SCANCMD > $IMGDIR/$IMGNAME"
echo "Command: $SCANCMD"
if ! eval $SCANCMD; then
    echo "Scanner errored while scanning. Rebooting."
    sudo reboot
fi
sudo umount $IMGDIR
