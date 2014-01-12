#!/bin/sh

export PROJECT_HOME="`dirname ${0}`/.."
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init -)"
cd $PROJECT_HOME

carton exec -- "$1"

