#! /bin/bash 
# USAGE: configure-cert.sh 
 
tdir=$(mktemp --directory)
pushd $tdir

git init
git config --global user.signingkey $(gpgsm --list-secret-keys | awk 'match($0,/0x/) {id =  substr($0, RSTART, 10)}END{print id}')
git config --global user.email $(gpgsm --list-secret-keys | awk 'match($0,/aka:/) {id =  substr($0, RSTART+5)}END{print id}')
git config --global gpg.program $(which gpgsm)
git config --global gpg.format x509

# git config --global user.signingkey $(gpg --list-secret-keys --keyid-format 0xlong | awk 'match($0,/0x/) {id =  substr($0, RSTART+2, 16)}END{print id}')
# git config --global gpg.program $(which gpg)

git config --global commit.gpgSign true
git config --global tag.gpgSign true
popd

rm -rf $tdir

# gah - silly terminal
export GPG_TTY=$(tty)
gpgconf --kill gpg-agent
