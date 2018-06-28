sudo yum update -y

sudo yum install -y epel-release yum-plugin-copr

# add a COPR dependency
sudo pip install urllib3 --upgrade
sudo pip install tldr
sudo pip install pygments

yum copr -y enable konimex/neofetch

sudo yum update -y
sudo yum install -y vim git tmux ack autojump neofetch curl

git clone https://github.com/ranger/ranger.git ~/src/ranger
pushd ~/src/ranger
sudo make install
popd

