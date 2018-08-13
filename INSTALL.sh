# make sure the script can be ran from any path
dir=`dirname $0`
pushd "$dir" > /dev/null

function installed {
  which $1 >/dev/null
}

# install homebrew
installed brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install ruby
brew install ruby

# fix missing dependency bug in rubygems.org
gem install minitar-cli

# https://tickets.puppetlabs.com/browse/FACT-804
gem install CFPropertyList

installed bundle || gem install bundler
bundle install --without development test && \
bundle exec librarian-puppet install && \
bundle exec puppet apply manifests/site.pp --modulepath=modules/

popd > /dev/null

