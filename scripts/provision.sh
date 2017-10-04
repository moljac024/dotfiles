# Raise inotify limit - This is safe as these dotfiles are meant to be used on a personal ubuntu install. I wouldn't do this on a server that is publically available
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# Install build-deps for ruby
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

# Install build-deps for python
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils

# Install common apps
sudo apt-get install -y git git-gui gitk vim tmux htop ncdu
