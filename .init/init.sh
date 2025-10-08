#!/bin/bash

if [ -f "$HOME/.init/path.sh" ] ; then
    . "$HOME/.init/path.sh"
fi

if [ -f "$HOME/.init/export.sh" ] ; then
    . "$HOME/.init/export.sh"
fi

if [ -f "$HOME/.init/alias.sh" ] ; then
    . "$HOME/.init/alias.sh"
fi

if [ -f "$HOME/.init/source.sh" ] ; then
    . "$HOME/.init/source.sh"
fi

if [ -f "$HOME/.init/functions.sh" ] ; then
    . "$HOME/.init/functions.sh"
fi

if [ -f "$HOME/.init/links.sh" ] ; then
    . "$HOME/.init/links.sh"
fi

if [ -f "$HOME/.init/source.sh" ] ; then
    . "$HOME/.init/source.sh"
fi

if [ -f "$HOME/.init/eval.sh" ] ; then
    . "$HOME/.init/eval.sh"
fi

if [ -f "$HOME/.init/trap.sh" ] ; then
    . "$HOME/.init/trap.sh"
fi

if [ -f "$HOME/.init/start.sh" ] ; then
    . "$HOME/.init/start.sh"
fi