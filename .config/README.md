# DO NOT DIRECTLY LINK THIS FOLDER TO $HOME/.config

**I REPEAT; DO NOT DIRECTLY LINK THIS FOLDER**

Many config files will store secrets in their configs.

**IF** you can control the secret management, you should put secrets in **~/.doNotCommit.d/** file.

If you can't, just make sure you DO NOT link the .config into **~/dotfiles/.config**.


# HowTo: .config

The .config folder is one of the folders specified in the [XDG
standard](https://wiki.archlinux.org/title/XDG_Base_Directory) and can be used to store, as the name
implies, configuration information for applications. While XDG recommends using an [OS
Keychain](https://www.freedesktop.org/wiki/Specifications/secret-storage-spec/) for secrets, not all
apps conform to this guideline.

## Existing/Initial config files

To use the files in this folder, one should symbolically link them into *$HOME/.config*
**INDIVIDUALLY**:

```bash
ln -sf $HOME/dotfiles/config_public/myapp $HOME/.config/myapp
```

> Note: You can also add the files you add to **dotfiles/setup/linkFiles.sh** !

## New Configs

As you bring on new applications, it is recommended that you do not, initially, move them into this
folder. If the app requires a username, password, token, etc., it very well could be saved in
`.config`.

**Setup the tool, use it for a while, and then verify that the settings are all sanitary.**

Then, and only then, you can relocate the file for versioning:

```bash
mv $HOME/.config/my_new_app $HOME/dotfiles/.config/my_new_app
ln $HOME/dotfiles/.config/my_new_app $HOME/.config/my_new_app
```

While it is not strictly required that you keep the same file/folder name when you move and link the
configuration, it will probably help you remember what the settings are for later!

> Note: all paths in this doc assuming your *dotfiles* and *.config* folders are in your *$HOME*
> folder.

