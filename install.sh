#!/bin/bash

CURRENTFOLDER=${PWD}

printf '\nInstalling Dependencies:'
apt update
apt install git build-essential meson

printf '\nDownloading, Building, and Installing SassC and LibSass:'
cd /usr/local/lib/
git clone https://github.com/sass/sassc.git --branch 3.2.1 --depth 1
git clone https://github.com/sass/libsass.git --branch 3.2.1 --depth 1

cd /usr/local/lib/sassc/
export SASS_LIBSASS_PATH="/usr/local/lib/libsass"
make

cd /usr/local/bin/
ln -s ../lib/sassc/bin/sassc sassc

cd ${CURRENTFOLDER}

printf '\nDownloading, Building, and Installing Communitheme-MATE:'

mkdir $HOME/.local/share/themes
mkdir $HOME/.themes

git clone https://github.com/Ubuntu/gtk-communitheme.git
git -C gtk-communitheme checkout 1a52b05

for file in patches/*.patch
do
  patch -p0 < "$file"
done

cd gtk-communitheme

meson builddir --prefix=$HOME/.local

ninja -C builddir install

ln -s $HOME/.local/share/themes/Communitheme-MATE $HOME/.themes/Communitheme-MATE

gsettings set org.mate.interface gtk-theme Communitheme-MATE
