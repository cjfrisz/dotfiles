#!/usr/bin/zsh

dest=$HOME
dotfiles_dir=`dirname $0`

foreach dot_file ( `ls -A $dotfiles_dir` )
  if [[ $dot_file != `basename $0` ]] ; then
    ( cd $dest && ln -s $dotfiles_dir/$dot_file )
  fi
end 
