# Additional configuration to set up this build host for ASAP

sudo apt-get update
sudo apt-get dist-upgrade

# LLVM and Co.
sudo apt-get install git clang cmake ninja-build binutils-dev

# Needed for running tests
sudo apt-get install gcovr mercurial parallel

# ASAP needs these
sudo apt-get install ruby ruby-dev
sudo gem install parallel

# Building python requires a few more
sudo apt-get install zlib1g-dev dpkg-dev

# Convenience
sudo apt-get install vim
