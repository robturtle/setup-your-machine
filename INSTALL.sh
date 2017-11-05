function installed {
  which $1 >/dev/null
}

# install homebrew
installed brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

installed bundle || gem install bundler
bundle install --without development test && \
librarian-puppet install && \
puppet apply manifests/site.pp --modulepath=modules/

