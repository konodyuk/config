# MacOS Configuration

## Usage
Install ansible (assuming python is installed):
``` sh
pip3 install ansible
```
Clone repo:
``` sh
git clone --recursive https://github.com/konodyuk/config
cd config
```
Run playbook in check mode:
``` sh
ansible-playbook -C playbook.yml --ask-become-pass
```
Start configuration:
``` sh
ansible-playbook playbook.yml --ask-become-pass
```
