sudo yum update -y

sudo yum install -y epel-release yum-plugin-copr

# add a COPR dependency
sudo pip install urllib3 --upgrade
sudo pip install tldr
sudo pip install ranger-fm

yum copr -y enable konimex/neofetch

sudo yum update -y
sudo yum install -y vim git tmux ack autojump neofetch curl shellcheck


# install nerd font
git clone https://github.com/ryanoasis/nerd-fonts ~/Downloads/fonts
pushd ~/Downloads/fonts
./install.sh Inconsolata
popd
