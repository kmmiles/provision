# provision

my provision scripts and dotfiles for ubuntu. works on metal, VM or WSL2.

## install

### workstation

Installs everything.

```bash
curl -s https://raw.githubusercontent.com/kmmiles/provision/main/bin/bootstrap | TYPE=workstation bash
```

### useronly

Installs dotfiles and $HOME tools. No root access.

```bash
curl -s https://raw.githubusercontent.com/kmmiles/provision/main/bin/bootstrap | TYPE=useronly bash
