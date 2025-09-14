My *personal* collection of install scripts to setup a fresh arch linux.
This is, of course, very customized and specific to my use-case.
Currently only has the option to install an unencrypted btrfs system.
The extension to make an encrypted version will come only once I need it and it will be made on demand.

Additionally, there is also a collection of not regularly updated `meta-packages` of programs I tend to install on each system, marked `dba-$topic`.

There is no further documentation, as this has no intention to useful for everyone.
If you know what you are looking for, you will find it ;).

* [**system_install.sh**](https://github.com/dbadrian/archbstrp/blob/main/system_install.sh): the basic install script, to be run from an archlinux live usb stick
* [**system_install_2nd_stage.sh**](https://github.com/dbadrian/archbstrp/blob/main/system_install_2nd_stage.sh): WIP...
* [**fix-grub.sh**](https://github.com/dbadrian/archbstrp/blob/main/fix-grub.sh): for some reason, my grub self-destructs sometimes...run from an archlinux live usb stick
* [**arch_usb_boot_creator.sh**](https://github.com/dbadrian/archbstrp/blob/main/arch_usb_boot_creator.sh): downloads latest arch iso and dd-copies the iso to the usb stick... 

## system_install.sh
```bash
curl -sL arch.dbadrian.com/system_install.sh | bash
```

## script relay via cloudflare

1. go to domain
2. Rules
3. Create Rule

- name: arch
- custom filter expression
- when incoming: hostname, equals, arch.dbadrian.com
- then: dynamic, concat("https://raw.githubusercontent.com/dbadrian/archbstrp/refs/heads/main/", http.request.uri.path), 301
- preserver query string TRUE
- place at: first

and system install one
- archgithub
- custom
- when incoming: hostname, equals, ab.dbadrian.com
- then: static, https://raw.githubusercontent.com/dbadrian/archbstrp/refs/heads/main/system_install.sh, 301
- place after arch

when deploying create new proxy dns: CNAME, name, dbadrian.com

curl -sL arch.dbadrian.com/system_install.sh | bash
curl -sL ab.dbadrian.com | bash
