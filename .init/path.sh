#!/bin/bash

if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.rvm/bin" ]; then
  export PATH="$HOME/.rvm/bin:$PATH"
fi

if [ -d "$HOME/repos/flutter/bin" ]; then
  export PATH="$HOME/repos/flutter/bin:$PATH"
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH="$PATH:$HOME/.rbenv/bin"
fi

if [ -d "$HOME/.pyenv/bin" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi

if [ -d "/opt/Upscayl/resources/bin" ]; then
  export PATH="$PATH:/opt/Upscayl/resources/bin"
fi

if [ -d "/usr/local/go/bin" ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi

if [ -d "$HOME/go/bin" ]; then
  export PATH="$PATH:$HOME/go/bin"
fi

if [ -d "$HOME/node_modules/.bin" ]; then
  export PATH="$PATH:$HOME/node_modules/.bin"
fi

if [ -d "$HOME/miniconda3/bin" ]; then
  export PATH="$PATH:$HOME/miniconda3/bin"
fi

if [ -d "$HOME/.local/share/flatpak/exports/share" ] ; then
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share"
fi

if [ -d "/var/lib/flatpak/exports/share" ] ; then
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share"
fi

if [ -d "$HOME/.init/bin" ] ; then
    export PATH="$PATH:$HOME/.init/bin"
fi

if [ -d "$HOME/Projects/kompose" ] ; then
    export PATH="$PATH:$HOME/Projects/kompose"
fi
