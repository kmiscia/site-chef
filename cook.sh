#!/bin/bash

# Current EC2 AMI is t1.micro instance with 15GB Magentic HDD running Ubuntu 12.04

usage() { echo "Usage: $0 [-i <string>] [-k <string>]" 1>&2; exit 1; }

USER=ubuntu

LOCAL_ENCRYPTION_KEYS=/Users/kmiscia/Workspace/site2/config/encryption
REMOTE_ENCRYPTION_KEYS=/home/vagrant

SWAP_SIZE=1024
SWAP_BLOCK_SIZE=1M
SWAP_LOCATION=/var/swap.1

LOCAL_CHEF_DIR=/Users/kmiscia/Workspace/site-chef

while getopts ":i:k:" o; do
  case "${o}" in
    i)
      IPADDRESS=${OPTARG}
      ;;
    k)
      KEYFILE=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${IPADDRESS}" ] || [ -z "${KEYFILE}" ]; then
  usage
fi

echo "Cooking $IPADDRESS using keyfile $KEYFILE..."

echo "Uploading encryption keys..."
ssh -i $KEYFILE $USER@$IPADDRESS "sudo mkdir -p ${REMOTE_ENCRYPTION_KEYS}"
ssh -i $KEYFILE $USER@$IPADDRESS "sudo chmod 777 ${REMOTE_ENCRYPTION_KEYS}"
scp -i $KEYFILE $LOCAL_ENCRYPTION_KEYS/* $USER@$IPADDRESS:$REMOTE_ENCRYPTION_KEYS

if ssh -i $KEYFILE $USER@$IPADDRESS stat $SWAP_LOCATION \> /dev/null 2\>\&1; then
  echo "Swap exists...not creating"
else
  echo "Swap not found...creating ${SWAP_SIZE} ${SWAP_BLOCK_SIZE} blocks at ${SWAP_LOCATION}"
  ssh -i $KEYFILE $USER@$IPADDRESS "sudo /bin/dd if=/dev/zero of=${SWAP_LOCATION} bs=${SWAP_BLOCK_SIZE} count=${SWAP_SIZE}"
  ssh -i $KEYFILE $USER@$IPADDRESS "sudo /sbin/mkswap ${SWAP_LOCATION}"
  ssh -i $KEYFILE $USER@$IPADDRESS "sudo /sbin/swapon ${SWAP_LOCATION}"
fi

ssh -i $KEYFILE $USER@$IPADDRESS "sudo apt-get install libgmp3-dev"

echo "Running knife solo prepare..."
cd $LOCAL_CHEF_DIR
bundle exec knife solo prepare $USER@$IPADDRESS -i $KEYFILE --bootstrap-version 12.20.3

NODE=$LOCAL_CHEF_DIR/nodes/$IPADDRESS.json

echo "Creating node file at ${NODE}"
cp -f $LOCAL_CHEF_DIR/nodes/.template $NODE
sed -i "s/ip_address/${IPADDRESS}/" $NODE

echo "Running knife solo cook..."
bundle exec knife solo cook $USER@$IPADDRESS -i $KEYFILE
