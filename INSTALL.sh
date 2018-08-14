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

installed bundle || gem install bundler
bundle config specific_platform true
bundle install --without development test && \
bundle exec librarian-puppet install && \
bundle exec puppet apply manifests/site.pp --modulepath=modules/

for p in iterm2 google-chrome slack dropbox typora intellij-idea postman spectacle; do
    brew cask install $p
done

popd > /dev/null

