encryption
===============

The purpose of this state is to create / maintain and mount encrypted volumes on EC2 while keeping the passphrase used to mount them off of the machine. The basic idea is if a machine is boot-strapped to fire up salt:

<pre>
#!/bin/bash
wget -O - http://salt.appliedminds.com/salt-bootstrap/bootstrap-salt.sh | sudo sh
sed -i 's/#master: salt/master: salt.<YOURDOMAIN>.com/g' /etc/salt/minion
service salt-minion restart
apt-get update
apt-get -y dist-upgrade
</pre>

A disk is added to the system:

<pre>
aws ec2 create-volume --availability-zone us-west-2a --size 8
aws ec2 attach-volume --volume-id <YOUR VOLUME> --instance-id <YOUR INSTANCE> --device /dev/sdf1
</pre>

Then, salt can do the rest.
