sudo yum update -y

sudo yum install -y epel-release yum-plugin-copr

# add a COPR dependency
sudo pip install urllib3 --upgrade
sudo pip install tldr
sudo pip install ranger-fm

sudo yum copr -y enable konimex/neofetch
sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo

sudo yum update -y
sudo yum install -y vim neovim git tmux ack ripgrep autojump neofetch curl shellcheck


# install nerd font
git clone https://github.com/ryanoasis/nerd-fonts ~/Downloads/fonts
pushd ~/Downloads/fonts
./install.sh Inconsolata
popd
