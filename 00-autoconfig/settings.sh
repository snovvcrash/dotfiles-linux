# Lower key press delay and repeat interval
## Not persistent
xset r rate 250 30
## Persistent
### GNOME
gsettings set org.gnome.desktop.peripherals.keyboard delay 250
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 33   # 1000/30 ≈ 33 ms = 30 cps
### Xfce
xfconf-query -c keyboards -p /Default/KeyRepeat/Delay --create -t int -s 250
xfconf-query -c keyboards -p /Default/KeyRepeat/Rate  --create -t int -s 30
### Windows
# Set-ItemProperty 'HKCU:\Control Panel\Keyboard' -Name KeyboardDelay -Value '0'   # 0-3 = 250/500/750/1000 ms
# Set-ItemProperty 'HKCU:\Control Panel\Keyboard' -Name KeyboardSpeed -Value '31'  # 0-31 ≈ 2.5-30 repeats/sec
