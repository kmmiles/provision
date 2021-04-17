# provision

my provision scripts and dotfiles for ubuntu. works on metal, VM or WSL2.

## install

### workstation

installs everything.

```bash
curl -s https://raw.githubusercontent.com/kmmiles/provision/main/bin/bootstrap | TYPE=workstation bash
```

### useronly

installs dotfiles and $HOME tools. no root access.

```bash
curl -s https://raw.githubusercontent.com/kmmiles/provision/main/bin/bootstrap | TYPE=useronly bash
```
