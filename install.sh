#!/bin/bash

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
