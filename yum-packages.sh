sudo yum update -y

sudo yum install -y epel-release yum-plugin-copr

# add a COPR dependency
sudo pip install urllib3 --upgrade
sudo pip install tldr
sudo pip install ranger-fm

sudo yum copr -y enable konimex/neofetch
sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo

sudo yum update -y
sudo yum install -y vim neovim git tmux ripgrep autojump neofetch curl shellcheck zsh


# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
  export RUNZSH=no 
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # custom plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# install starship
if ! command -v starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh
fi

# install nerd font
while true; do
  read -rp "Do you want to install nerd fonts? (Y/n): " yn
  case $yn in
    [Yy]* ) INSTALL_FONTS=1; break;;
    [Nn]* ) INSTALL_FONTS=0; break;;
    '' ) INSTALL_FONTS=1; break;;
    * ) echo "Please answer y or n";;
  esac
done

if [ $INSTALL_FONTS -eq 1 ]; then
  git clone https://github.com/ryanoasis/nerd-fonts ~/Downloads/fonts
  pushd ~/Downloads/fonts
  ./install.sh Inconsolata
  popd
fi
