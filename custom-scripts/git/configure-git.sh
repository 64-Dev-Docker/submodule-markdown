#! /bin/bash

tdir=$(mktemp --directory)
pushd $tdir
git init
git config --global core.editor "nvim"
popd
rm -rf $tdir
