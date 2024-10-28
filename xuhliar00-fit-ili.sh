# Author xuhliar00

yum install -y httpd createrepo

echo "1. Creating 200MB file /var/tmp/ukol.img"
dd if=/dev/zero of=/var/tmp/ukol.img bs=200M count=1

echo "2. Setting loop device for /var/tmp/ukol.img"
losetup /dev/loop0 /var/tmp/ukol.img

echo "3. Creating ext4 filesystem for /dev/loop0"
mkfs.ext4 /dev/loop0

echo "4. Creating directory /var/www/html/ukol and adding /var/tmp/ukol.img to /etc/fstab for automatic mounting"
mkdir -p /var/www/html/ukol
echo "/var/tmp/ukol.img /var/www/html/ukol ext4 defaults 0 0" >> /etc/fstab
echo "Reloading daemon because fstab has been modified"
systemctl daemon-reload
echo "5. Mounting /dev/loop0 to /var/www/html/ukol"
mount /dev/loop0 /var/www/html/ukol

echo "6. Downloading packages without installation from script arguments to /var/www/html/ukol"
if [ "$#" -eq 0 ]; then
    echo "No arguments were provided"
else
    echo "Downloading packages to /var/www/html/ukol"
    yum install -y --downloadonly --downloaddir=/var/www/html/ukol "$@"
fi

echo "7. Generating repodata for packages in /var/www/html/uhol"
echo "Downlaoding and installing createrepo package"
createrepo /var/www/html/ukol

echo "Setting selinux context for /var/www/html/ukol"
restorecon -Rv /var/www/html/ukol

echo "8. Configuring /etc/yum.repos/ukol.repo"
cat << EOF > /etc/yum.repos.d/ukol.repo
[ukol]
name=Repo Ukol
baseurl=http://localhost/ukol
enabled=1
gpgcheck=0
EOF

echo "9. Installing and setting up apache"
systemctl start httpd

echo "10. Listing available yum repositories"
yum repolist

echo "11. Unmounting filesystem mounted to /var/www/html/ukol"
umount /var/www/html/ukol

echo "12. Running mount -a to remount loop device to /var/www/html/ukol"
mount -a
mount | grep /var/www/html/ukol

echo "13. Displaying package info for ukol"
yum clean all
yum --disablerepo="*" --enablerepo="ukol" list --available

echo "Script finished"

