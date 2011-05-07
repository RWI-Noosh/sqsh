#!/bin/bash
# install.sh
# Installs symlinks in $HOME to point to the dotfiles in the repo.
# If the repo directory is moved this script will need to be run again.
# Old dotfiles are saved in a tarball in $HOME.

# List of dotfiles and dotfolders to create symlinks to in $HOME.
dotfiles=$(cat <<EOF
.profile
.gitconfig
.hgrc
.inputrc
.perlrc
.screenrc
.vim
.vimrc
EOF
)

preexisting_dotfiles=$(
    for file in $dotfiles; do
    	if [[ -e $HOME/$file ]]; then
    		echo $file
    	fi
    done
)

# Backup preexisting dotfiles
tar -C $HOME -czf $HOME/dotfile_$(date +%FT%T).bak.tar.gz $preexisting_dotfiles

repodir=$(dirname $0)
for file in $dotfiles; do
    if [[ -f $HOME/$file ]]; then
    	rm $HOME/$file
    elif [[ -d $HOME/$file ]]; then
        rm -rf $HOME/$file
    fi
    ln -s $repodir/dotfiles/${file#.} $HOME/$file
done
