sudo apt install dconf-editor dconf-cli -y
dconf dump /com/gexperts/Tilix/ > tilix.dconf
dconf load /com/gexperts/Tilix/ < tilix.dconf

# Build from source
# sudo apt install -y git meson ninja-build
# git clone https://github.com/gnunn1/tilix.git
# cd tilix && mkdir build && cd build
# meson setup ..
# ninja
# sudo ninja install
# sudo glib-compile-schemas /usr/share/glib-2.0/schemas
# sudo update-desktop-database /usr/share/applications
