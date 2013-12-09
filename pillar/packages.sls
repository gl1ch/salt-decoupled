packages:
{% if grains['os_family'] == 'Debian' %}
  cryptsetup: cryptsetup-bin
  lvm2: lvm2
{% elif grains['os_family'] == 'RedHat' %}
  cryptsetup: cryptsetup-bin
  lvm2: lvm2
{% endif %}
