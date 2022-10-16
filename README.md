# Configuration Stuff

## Usage

### Initial Installation

Install the essential utilities:

```sh
curl -fsSL https://raw.githubusercontent.com/konodyuk/config/main/bin/bootstrap | bash -s -- essentials
```

Clone the repo:

```sh
git clone https://github.com/konodyuk/config.git
```

Configure shell and utilities:

```sh
./bin/bootstrap init_repo
./bin/bootstrap shell
./bin/bootstrap dotfiles
```

Restart the shell.

### Stages

Apply the remaning stages:

```sh
bootstrap           # show available stages
bootstrap <stage>   # apply stage
```

Example order:

```sh
bootstrap macos_defaults
bootstrap sudo_touchid
bootstrap iterm
bootstrap obsidian
bootstrap apps
```

For more granular control invoke pyinfra directly:

```sh
pyinfra @local deploys/<name>.py
```

## QuickConf

Minimal, unprivileged and isolated dev configuration.

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

**Install**:

```sh
curl -fsSL https://raw.githubusercontent.com/konodyuk/config/main/scripts/quickconf.sh | bash -s -- install
```

**Update**:

```sh
quickconf update
```

**Uninstall**:

```sh
quickconf uninstall
```

or

```sh
curl -fsSL https://raw.githubusercontent.com/konodyuk/config/main/scripts/quickconf.sh | bash -s -- uninstall
```
