My *personal* collection of install scripts to setup a fresh arch linux.
This is, of course, very customized and specific to my use-case.
Currently only has the option to install an unencrypted btrfs system, which the encrypted version of these scripts no integrated yet.

Additionally, there is also a collection of not regularly updated `meta-packages` of programs I tend to install on each system, marked `dba-$topic`.

There is no further documentation, as this has no intention to useful for everyone.
If you know what you are looking for, you will find it ;).

```bash
pacman -Sy git
git clone https://github.com/dbadrian/archbstrp.git
cd archbstrp
bash system_install.sh
```
