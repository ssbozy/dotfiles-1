#maybe add something to add myself as a user?

# Assume that it's been cloned into ~/dotfiles/

# mkdir ~/dot-bak/
# cd dotfiles
# find . -type f -not -ipath '*.git/*' -exec mv ~/{} ~/dot-bak/ \;
# cd ~
# find dotfiles/ -type f -not -ipath '*.git/*' -exec ln -s {} \;

# For our CentOS VMs, if I want tmux, I gotta:
# rpm -ivh http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
# yum install tmux
