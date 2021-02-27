# provision

my provision scripts and dotfiles for ubuntu and debian

## install

### ubuntu workstation

```bash
cd ~ && \
git clone https://github.com/kmmiles/provision.git && \
cd provision && \
./bin/workstation
```

### debian workstation

```bash
sudo apt update && \
sudo apt -y --no-install-recommends install \
  git \
  ca-certificates \
&& \
cd ~ && \
git clone https://github.com/kmmiles/provision.git && \
cd provision && \
./bin/workstation
```

## about

a toplevel `workstation` script executes a series of scripts to perform the following: 

- disables password prompts for `sudo`
- performs apt update and upgrade
- apt installs base and dev packages
- links my dotfiles to `$HOME`
- installs `qemu` and `podman`
- installs additional tools to `$HOME/.local/bin` e.g. `prettyping`, `exa`, `glow`, and `youtube-dl`.
- installs the `ale` and `gruvbox` plugins for `vim` and `nvim`

some special steps are done if we're using wsl2:

- the users home directory on windows is symlinked to `$HOME/winhome`.
  `$HOME/Downloads` and `$HOME/Music` will point to the windows drive.
- apt packages are cached in `$HOME/Downloads/apt` and will persist
- `podman` will be configured specifically for wsl2
