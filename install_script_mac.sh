#!/bin/bash

# TODO ugly hack, but brew doesn't like "which"

git submodule init && git submodule update

./install_dot_files.rb -g

cp Workman-P.keylayout ~/Library/Keyboard\ Layouts/

osascript add_workman.scpt
# TODO Need further testing on how to revert to original
# osascript make_caps_lock_control.scpt
