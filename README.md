# Configuration Stuff

## Usage

...

## QuickConf

Minimal, unpriveleged and isolated dev configuration.

Installs and configures:
- `nvim`
- `starship`
- `inv`: interactive `nvim` python repl
- utils: `fzf`+`ripgrep`

Applies the following changes:
- writes all binaries, configs, and auxiliary files into `~/.quickconf` folder
- optionally inserts 2 lines into `~/.bashrc` and `~/.bash_profile`

External, i.e. not managed deps:
- `isort`+`black`: for format-on-save
- `node`: for language servers
- `ipython`: for `inv`

**Installation**:

```sh
curl -fsSL https://raw.githubusercontent.com/konodyuk/config/main/scripts/quickconf.sh | bash
```

**Uninstallation**:

```sh
curl -fsSL https://raw.githubusercontent.com/konodyuk/config/main/scripts/quickconf.sh | bash -s -- uninstall
```
