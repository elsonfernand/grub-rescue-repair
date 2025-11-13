# 🧭 Recuperação do GRUB no Arch Linux (EFI)

> Tutorial definitivo para restaurar o GRUB quando o sistema pede para selecionar uma unidade bootável.

### ⚙️ Preparação inicial

Para facilitar a digitação em teclados ABNT2:
```
loadkeys br-abnt2
```

Certifique-se de estar no ambiente live do Arch Linux (por exemplo, via pendrive bootável).

### 🧩 1. Montar as partições

Monte as partições do seu sistema antes de entrar no chroot.

O meu layout, no exemplo desse tutorial, está assim (use o comando `lsblk` se estiver perdido):
```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
zram0       254:0    0   7.7G  0 disk [SWAP]
nvme0n1     259:0    0 232.9G  0 disk
├─nvme0n1p1 259:1    0   512M  0 part /boot/efi
├─nvme0n1p2 259:2    0    80G  0 part /
└─nvme0n1p3 259:3    0 152.4G  0 part /home
```
Ajuste conforme o seu layout e monte a partição de boot (aqui eu monto tudo só pra ficar mais calmo mesmo kkkk):
```
mount /dev/nvme0n1p2 /mnt
mount /dev/nvme0n1p3 /mnt/home
mount /dev/nvme0n1p1 /mnt/boot/efi
```
### 🧱 2. Entrar no ambiente chroot
```
arch-chroot /mnt
```
### 📦 3. Reinstalar pacotes essenciais

Por precaução, reinstale o GRUB e o efibootmgr:
```
pacman -S grub efibootmgr
```
### 🔁 4. Reinstalar o GRUB

Refaça a instalação do GRUB para a partição EFI:
```
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --removable --recheck
```
### 🧮 5. Gerar novamente o arquivo de configuração
```
grub-mkconfig -o /boot/grub/grub.cfg
```
### 🧷 6. Recriar a entrada de boot (caso ainda não apareça na BIOS/UEFI)

Se o sistema ainda não inicializar automaticamente, recrie a entrada de boot:
```
efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Arch Linux" --loader '\EFI\arch_grub\grubx64.efi'
```

Esse comando adiciona novamente o Arch Linux na lista de inicialização UEFI.

### 🚪 7. Finalizar

Saia do chroot e reinicie o sistema:
```
exit
reboot
```

### ✅ Pronto!
Seu GRUB deve estar restaurado e funcional.
É pra funcionar. 😎 kkkkk
