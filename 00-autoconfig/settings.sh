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
## For Windows:
## reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatDelay" /t REG_SZ /d "0" /f
## reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "AutoRepeatRate" /t REG_SZ /d "0" /f
## reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "DelayBeforeAcceptance" /t REG_SZ /d "0" /f
