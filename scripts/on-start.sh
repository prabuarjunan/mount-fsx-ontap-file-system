#!/bin/bash
set -e
# OVERVIEW
# This script mounts a FSx for ontap file system to the Notebook Instance at the /fsx directory based off
# the IP address and Mount name parameters.
#
# This script assumes the following:
#   1. There's an FSx for NetApp Ontap file system created and running
#   2. The FSx for NetApp Ontap file system is accessible from the Notebook Instance
#       - The Notebook Instance has to be created on the same VPN as the FSx for NetApp Ontap file system
#       - The subnets and security groups have to be properly set up
#   3. Set the FSXo_DNS_NAME parameter below to the DNS name of the FSx for NetApp Ontap file system.
#   4. Set the FSXo_MOUNT_NAME parameter below to the Mount name of the FSx for NetApp Ontap file system.
# PARAMETERS
FSXo_DNS_NAME=198.19.255.64 #<Enter the IP address of the FSX for NetApp Ontap file system>
FSXo_MOUNT_NAME=fsx  #<Enter the mount point name>
SVM_NAME=svm-0123456 #<Enter the SVM ID>
FSXo_ID=fs-0123456   #<Enter the FSX for NetApp Ontap ID>
#add the route to the notebook instance.
sudo route add -net 198.19.0.0/16 dev eth2 #<Enter the CIDR range of the FSX for NetApp Ontap file system NFS IP range>
# First, we need to install the nfs-client libraries
sudo yum install -y nfs-utils
# Now we can create the directory
sudo mkdir /fsx
# Now we can create the mount point and mount the file system
sudo mount -t nfs $FSXo_DNS_NAME:/vol1 /fsx
# Now we can create the Directory to place the config file
sudo mkdir /home/ec2-user/.netapp_dataops
# Now we can create the config file
sudo touch /home/ec2-user/.netapp_dataops/config.json
# Now change the permission of the config file
sudo chmod 777 /home/ec2-user/.netapp_dataops/config.json
#  The json input for the NetApp DataOps Tollkit for traditional environments
#  The toolkit requires an ONTAP account with API access. The toolkit will use this account to access the ONTAP API. NetApp recommends using an SVM-level account.
#  Copy the JSON file created using the following steps from getting started step in the link https://github.com/NetApp/netapp-dataops-toolkit/tree/main/netapp_dataops_traditional
#  required for the API access
#  Change the hostname, SVM, dataLif, password accordingly. Example: "hostname": "198.19.0.0", "svm": "test-svm", "dataLif": "198.19.0.0", "password": "TmV0QXBwMTIz"
json='{"connectionType": "ONTAP", "hostname": "198.19.255.64", "svm": "prabu-sim", "dataLif": "198.19.255.64", "defaultVolumeType": "flexgroup", "defaultExportPolicy": "default", "defaultSnapshotPolicy": "none", "defaultUnixUID": "0", "defaultUnixGID": "0", "defaultUnixPermissions": "0777", "defaultAggregate": "aggr1", "username": "vsadmin", "password": "TmV0QXBwMTIz", "verifySSLCert": false}'
# The copy the json input to the config.json to the folder
sudo echo $json >> /home/ec2-user/.netapp_dataops/config.json
# Install the NetApp DataOps Toolkit for Traditional Environments
python3 -m pip install netapp-dataops-traditional
# Let's make sure we have the appropriate access to the directory
sudo chmod go+rw /fsx
