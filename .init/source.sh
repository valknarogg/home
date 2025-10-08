#!/bin/bash

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ -s "$NVM_DIR/nvm.sh" ] ; then
    . "$NVM_DIR/nvm.sh"
fi

if [ -s "$NVM_DIR/bash_completion" ] ; then
    . "$NVM_DIR/bash_completion"
fi

if [ -s "$HOME/.rvm/scripts/rvm" ] ; then
    . "$HOME/.rvm/scripts/rvm"
fi

if [ -s "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi
