# Install fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install plugins listed in fish_plugins
fisher update

# Symlink setup to conf.d so it runs before plugins
set -l here (path resolve (dirname (status --current-filename)))
set -l target $here/init.fish
set -l dest $here/conf.d/000.init.fish

mkdir -p (dirname $dest)

if test -e $dest
  rm $dest
end

ln -sf $target $dest
