## Setup

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt install neovim
mkdir -p ${HOME}/.config
cd ${HOME}/.config
git clone git@github.com:dbobrenko/nvim.git nvim
cd nvim
bash install.sh
# Move tmux config.
# Note: it will overwrite your existsing tmux config, if any.
mv .tmux.conf ${HOME}/.tmux.conf
```
