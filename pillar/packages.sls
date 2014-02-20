packages:
{% if grains['os_family'] == 'Debian' %}
  cryptsetup: cryptsetup-bin
  lvm2: lvm2
  ssh: ssh
  ssh-service: ssh
{% elif grains['os_family'] == 'RedHat' %}
  cryptsetup: cryptsetup-bin
  lvm2: lvm2
  ssh: openssh
  ssh-service: sshd
{% endif %}
