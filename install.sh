#!/bin/bash

## VARS ##
dir=~/dotfiles
olddir=~/dotfiles_old
files="emacs bashrc bash_profile gitconfig gitignore"

echo "Creating dir to save old files"
mkdir -p $olddir

echo "Switching to dotfiles dir"
cd $dir

for file in $files; do
    echo "Moving $file"
    mv ~/.$file $olddir
    ln -s $dir/$file ~/.$file
done

