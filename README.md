# provision

ubuntu / debian provision scripts

## workstation

```bash
set -eux; \
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
