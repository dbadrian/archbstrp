# How to host local arch linux PXE server

This is just a brief list of details for myself, check arch linux wiki for more.

### the fast way
- Fastest is to install pixiecore and `sudo pixicore quick arch` on some machine on the local network
- This will provide a netboot image, which means a lot of time might have to be spend downloading. given germanys crap internet situation, I still have reasonably slow internet. preferably a local hosting would be nice

### the longterm way, that is faster to boot form

1. download the lastest archlinux image
2. extract it, e.g. `mkdir netboot-files && bsdtar -xvf archlinux*x86_64.iso -C netboot-files`
3. `cd netboot-files`
4. start local http server to serve the files `python3 -m http.server 8080`
5. start pixiecore `sudo pixiecore boot /home/kobold/netboot/arch/boot/x86_64/vmlinuz-linux /home/kobold/netboot/arch/boot/x86_64/initramfs-linux.img   --cmdline "ip=dhcp archiso_http_srv=http://192.168.178.124:8080/ archisobasedir=arch"`
6. profit

### as system service setup
```
wget ....
sudo mkdir /srv/arch-netboot
sudo bsdtar -xvf archlinux*x86_64.iso -C /srv/arch-netboot

sudo tee /etc/systemd/system/arch-netboot-http.service > /dev/null <<'EOF'
WorkingDirectory=/srv/arch-netboot
ExecStart=/usr/bin/python3 -m http.server 8080
User=nobody
Group=nobody
KillMode=process
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo tee /etc/systemd/system/pixiecore.service > /dev/null <<'EOF'
[Unit]
Description=Pixiecore PXE Boot Server for Arch netboot
After=network.target arch-netboot-http.service
Wants=arch-netboot-http.service

[Service]
ExecStart=/usr/bin/pixiecore boot \
    /srv/arch-netboot/arch/boot/x86_64/vmlinuz-linux \
    /srv/arch-netboot/arch/boot/x86_64/initramfs-linux.img \
    --cmdline "ip=dhcp archiso_http_srv=http://kobold:8080/ archisobasedir=arch"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now arch-netboot-http.service
sudo systemctl enable --now pixiecore.service

systemctl status pixiecore.service
systemctl status arch-netboot-http.service

```
