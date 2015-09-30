#!/bin/bash

if [ -z $(which brew) ]; then
    # Install brew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

git submodule init && git submodule update
