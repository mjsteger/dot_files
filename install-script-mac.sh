#!/bin/bash

# TODO ugly hack, but brew doesn't like "which"
if [ ! -f "/usr/local/bin/brew" ]; then
    # Install brew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

git submodule init && git submodule update

./install-dot-files -g

cp Workman-P.keylayout ~/Library/Keyboard\ Layouts/

osascript add_workman.scpt
# TODO Need further testing on how to revert to original
# osascript make_caps_lock_control.scpt
