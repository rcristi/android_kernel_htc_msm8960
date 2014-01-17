CROSS_COMPILE=/home/andrew/htc/kernels/toolchains/arm-cortex_a15/bin/arm-cortex_a15-linux-gnueabi-
INITRAMFS_DIR=ramdisk.gz
KERNEL_NAME=-IronBorn-
KERNEL_VNUMBER=0.5

# DO NOT MODIFY BELOW THIS LINE
CURRENT_DIR=`pwd`
NB_CPU=`grep processor /proc/cpuinfo | wc -l`
let NB_CPU+=1
if [[ -z $1 ]]
then
	echo "No configuration file defined"
	exit 1

else 
	if [[ ! -e "${CURRENT_DIR}/arch/arm/configs/$1" ]]
	then
		echo "Configuration file $1 not found"
		exit 1
	fi
	CONFIG=$1
fi


export KBUILD_BUILD_VERSION="${KERNEL_NAME}-v${KERNEL_VNUMBER}"


make $1
echo "Building kernel ${KBUILD_BUILD_VERSION} with configuration $CONFIG"
make ARCH=arm -j$NB_CPU CROSS_COMPILE=$CROSS_COMPILE

cd kcontrol_gpu_msm
make
cd ..
cp arch/arm/boot/zImage /home/andrew/htc/kernels/ModBubba
find . -name \*.ko -exec cp '{}' /home/andrew/htc/kernels/ModBubba/modules/ ';'
git clean -f -d

echo "Done."
