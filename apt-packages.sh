HAS_GUI=$1

sudo apt-get update

sudo apt-get install -y git python3-dev python3-pip vim-gtk ack-grep autojump ranger tldr curl xclip

if [ "$HAS_GUI" = true ]; then
  sudo apt-get install -y unity-tweak-tool ubuntu-restricted-extras \
    redshift redshift-gtk default-jre guake exfat-fuse exfat-utils \
    ttf-ancient-fonts libxml2-dev libxslt-dev
fi

sudo add-apt-repository ppa:dawidd0811/neofetch
sudo apt-get update
sudo apt-get install -y neofetch

