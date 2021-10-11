#!/bin/bash

set -e

# OVERVIEW
# This script mounts a FSx for ontap file system to the Notebook Instance at the /fsx directory based off
# the DNS/IP address and Mount name parameters.
#
# This script assumes the following:
#   1. There's an FSx for NetApp Ontap file system created and running
#   2. The FSx for NetApp Ontap file system is accessible from the Notebook Instance
#       - The Notebook Instance has to be created on the same VPN as the FSx for NetApp Ontap file system
#       - The subnets and security groups have to be properly set up
#   3. Set the FSXo_DNS_NAME parameter below to the DNS name of the FSx for NetApp Ontap file system.
#   4. Set the FSXo_MOUNT_NAME parameter below to the Mount name of the FSx for NetApp Ontap file system.

# PARAMETERS
FSXo_DNS_NAME=IPaddress/DNS
FSXo_MOUNT_NAME=fsx
SVM_NAME=svm-0123456
FSXo_ID=fs-0123456

# First, we need to install the ontap-client libraries

# Now we can create the mount point and mount the file system
sudo mkdir /fsx
sudo mount -t nfs FSXo_DNS_NAME:/vol1 /fsx


# Let's make sure we have the appropriate access to the directory
sudo chmod go+rw /fsx