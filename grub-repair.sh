#!/usr/bin/env bash
# Script para recuperação do GRUB inspirado em experiências reais
# de recuperação de GRUB em sistemas Arch Linux com NVMe e UEFI.

set -e

echo "==> Montando partições..."
mount /dev/nvme0n1p2 /mnt
mount /dev/nvme0n1p1 /mnt/boot/efi
mount /dev/nvme0n1p3 /mnt/home

echo "==> Entrando no chroot e reinstalando pacotes..."
arch-chroot /mnt /bin/bash <<'EOF'
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --removable --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# Verificar e criar entrada EFI se necessário
if ! efibootmgr -v | grep -q "Arch Linux"; then
    efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Arch Linux" --loader '\EFI\arch_grub\grubx64.efi'
fi
EOF

echo "==> Desmontando partições..."
umount -R /mnt

echo "==> Sincronizando e reiniciando..."
sync
reboot
