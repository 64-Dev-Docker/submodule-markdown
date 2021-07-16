# Markdown

This is intended to be used as a git sub-module. 

To use in an existing repo first delete the existing `.devcontainer` folder and commit this change.

```bash
git rm -rf .devcontainer\
```

Then clone and update the .devcontainer submodule.

```bash
cd {root project}
git submodule add https://github.com/waltiam/submodule-markdown.git .devcontainer
git submodule init
git submodule update
```

If you make change to the .devcontainer that you want to commit back to the repo.

```bash
cd {project root}/.devcontainer
git add {changes to add}
git commit -m"{commit mesage}"
git push
cd ..
git submodule update
```

33 General WSL

- [Configuring WSL](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig)

## SSH and Commit Signing

### SSH

The general idea is that I do not want tokens, credentials or passwords in the repo.  This means there will be inevitably some manual steps happening.  To start with we share the ~/.ssh folder with the docker image as ${user}/.ssh, as long as the ssh token have been properly configured in github this should work.

```json
    "source=${localEnv:HOME}/.ssh,target=/home/vscode/.ssh,type=bind,consistency=cached",
```

### Commit Signing

A little more complex because there are actual manual steps to create the and sign the token.

> Taking the steps to create a gpg cert from [Signing your GitHub commits using GPG keys on Windows](https://kolappan.dev/blog/2021/signing-your-commits/).

Configure a gpg commit signing key on the WSL instance.

```sh
gpg --full-key-gen --pinentry-mode loopback
... etc
```

- The important thing here is the `--pinentry-mode loopback` and be sure that `export GPG_TTY=$(tty)` has been added to the shell rc file.

Again though, let's start with sharing the folder where the gpg token is stored.  Mount e `~/.gnupg` folder with the dev container:

```json
    "source=${localEnv:HOME}/.gnupg,target=/home/vscode/.gnupg,type=bind,consistency=cached",
```

Run the git configuration steps on the docker image, this will require the public key.

The final piece of the puzzle, the GPG commit signing requires a encryption key. Once the PGP key is generated in the WSL environment this "should just work" &trade; .  Almost, the key turned out to be that for some reason the docker dev container doesn't take the default recipient, fixed that by adding the following line into the `~/.gnupg/gpg.conf` file:

```
recipient {your email accosicated with the token}
```

### Sectigo x.506 - s/mime

Run through the setup in as per the [Sectigo Documentation](https://confluence.comodoca.net/pages/viewpage.action?pageId=115377205).  When it comes to the part about configuring git the commands should be executed in the .devcontainer, only the following are really needed and could be scripted out per user and stored outside the container:

```sh
git config --global gpg.program $(which gpgsm)
git config --global gpg.format x509
git config --global user.signingkey 0xDDDDDDDD
git config --global user.email 'walt.speelman@sectigo.com'
```

Somewhere, I cannot find the original post anywhere, it was said that the command `export GPG_TTY=$(tty)` also needed to be executed.

This seems to fix a couple of errors too:

```sh
gpgconf --kill gpg-agent
```

Other things that I still need to explore to help stablize the signing environment:

- `gpgconf --kill gpg-agent`
- `echo UPDATESTARTUPTTY | gpg-connect-agent`

### Resources that Got Us Here

- [Started with this](https://kolappan.dev/blog/2021/signing-your-commits/)
- [creating subkeys](https://oguya.ch/posts/2016-04-01-gpg-subkeys/)
- [Git - the horses mouth](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
- [The hint that said we needed an encryption key](http://www.verycomputer.com/92_d9ba28a257565c3a_1.htm)
- [Parsing the GPG output with **awk**](https://www.tutorialspoint.com/awk/awk_basic_examples.htm)
- [GPG - though the actual `man gpg` was more useful](https://www.tutorialspoint.com/unix_commands/gpg.htm)
- [Git - starting page of the set up for Github](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/about-commit-signature-verification)
- [Some interesting stuff, can't remember if this actually told me anything new though](https://medium.com/@rwbutler/signing-commits-using-gpg-on-macos-7210362d15#:~:text=%20Signing%20Commits%20Using%20GPG%20on%20macOS%20,Alternatively%20when%20committing%2C%20supply%20the%20-S...%20More%20)
- [Where you're gonna store these things on GitHub](https://github.com/settings/keys)
- [The online manpage for `gpgsm`](https://linux.die.net/man/1/gpgsm)
- [Configuring `GPG_TTY`](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html#Agent-Examples)

## More information:

- [Atlassian Intro](https://www.atlassian.com/git/tutorials/git-submodule)
- [Git Details](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

The _template-golang_ has this sub-module already inserted.

If you make changes to this submodule remember to add and commit from the `.devcontainer` folder.

Licensed under the MIT License.

//! TODO: add license file
