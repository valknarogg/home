# home

## Installation

```bash
# sudo usermod -a -G sudo $USER
sudo apt install git ansible
git config --global init.defaultBranch main
git config --global --add safe.directory /home/$USER
git init && git remote add origin git@github.com:valknarogg/home.git
git fetch && git reset --hard origin/main
git branch --set-upstream-to=origin/main main
sudo -u $USER ansible-playbook -K playbook.yml
```


## Ansible

```bash
sudo -u valknar ansible-playbook --tags oh-my-posh -K playbook.yml
```
