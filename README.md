# setup-your-machine
[![Build Status](https://semaphoreci.com/api/v1/robturtle/setup-your-machine/branches/production/badge.svg)](https://semaphoreci.com/robturtle/setup-your-machine)

USAGE:
```
./INSTALL.sh
```

If you want to know what packages and configurations are being installed, check the [site.pp](manifests/site.pp). Note is under development stage for now and heavy changes are expected in the future. So this site.pp shall be the current authentic document.

If you encounter any problems, feel free to make a github issue.

Use it to auto deploy developing environment. The reason not to use Boxen is mainly about keeping the environemt with least dependencies and light-weighted.

- [ ] install applications in app store from CLI (paste)
- [ ] activate license from CLI [alfred, bartender, JetBrains]
- [ ] change keyboard (modifier keys, shortcuts)
- [ ] paramegerized config (GUI admin)
- [ ] setup email accounts
- [ ] cleanup desktop docker
- [ ] defaults write iterm2.??? (dropdown, powerline fonts) (`~/Library/Application Support/iTerm*` `com.googlecode.iterm2*`)
- [ ] disable trackpad when typing

