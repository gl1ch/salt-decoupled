{% set password = pillar['encryption']['password'] %}
{% set devname = pillar['encryption']['dev_name'] %}
{% set volgroup = pillar['encryption']['vg_name'] %}
{% set mountpoint = pillar['encryption']['mount_name'] %}
{% set dev_check = salt['file.is_blkdev'](devname + '1') %}

crypto-package:
  pkg:
    - name: {{ pillar['packages']['cryptsetup'] }}
    - order: 10
    - installed

lvm2-package:
  pkg:
    - name: {{ pillar['packages']['lvm2'] }}
    - order: 11
    - installed

{% if dev_check == False %}
fdisk_run:
  cmd.run:
    - name: |
        sfdisk -L {{ devname }} << EOF
        ;
        EOF
        {{ dev_check }}
    - order: 12
{% endif %}

{{ devname }}1:
  lvm.pv_present:
    - order: 100

volume_data:
  lvm.vg_present:
    - devices: {{ devname }}1
    - order: 101

{{ mountpoint }}:
  lvm.lv_present:
    - vgname: volume_data
    - extents: 100%FREE 
    - order: 102

enc_volume:
  cmd.run:
    - unless: cryptsetup luksUUID /dev/volume_data/{{ mountpoint }}
    - name: echo "{{ password }}" | cryptsetup luksFormat /dev/volume_data/{{ mountpoint }}
    - order: 103

enc_volume_open:
  cmd.run:
    - unless: stat /dev/mapper/{{ mountpoint }}
    - name: echo "{{ password }}" | cryptsetup luksOpen /dev/volume_data/{{ mountpoint }} {{ mountpoint }}
    - order: 104

enc_volume_format:
  cmd.run:
    - unless: lsblk -f /dev/mapper/{{ mountpoint }} | grep ext4
    - name: mkfs.ext4 /dev/mapper/{{ mountpoint }}
    - order: 105

enc_volume_mount:
  mount.mounted:
    - name: /{{ mountpoint }}
    - device: /dev/mapper/{{ mountpoint }}
    - fstype: ext4
    - mkmnt: True
    - persist: False
    - order: 106
