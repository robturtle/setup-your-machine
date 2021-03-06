if $::osfamily == 'Darwin' {
    Package {
        provider => 'brew',
    }
    $home = "/Users/${::id}"
} else {
    $home = "/home/${::id}"
}

Exec {
    environment => [ "HOME=${home}" ]
}

if $::osfamily == 'Darwin' {

    # Mac System-wise Emacs Key Bindings
    file { "${home}/Library/KeyBindings":
        ensure => directory
    }
    -> file { "${home}/Library/KeyBindings/DefaultKeyBinding.dict":
        ensure => present,
        source => 'https://gist.githubusercontent.com/cheapRoc/9670905/raw/1c1cd2e84daf07c9a4c8de0ff86d1baf75d858c6/EmacsKeyBinding.dict',
    }

    # Defaults
    macdefaults { 'finder-show-all-file-extensions':
        domain => 'NSGlobalDomain',
        key    => 'AppleShowAllExtensions',
        type   => 'bool',
        value  => true,
        notify => Exec[restart_finder],
    }
    exec { 'restart_finder':
        command     => 'killall Finder',
        path        => '/usr/bin:/bin',
        refreshonly => true,
    }

    macdefaults { 'disable-screenshot-window-shadows':
        domain => 'com.apple.screencapture',
        key    => 'disable-shadow',
        type   => 'bool',
        value  => true,
        notify => Exec[restart_UI],
    }
    exec { 'restart_UI':
        command     => 'killall SystemUIServer',
        path        => '/usr/bin:/bin',
        refreshonly => true,
    }

    macdefaults { 'stop-open-photos-when-connect-to-iphone-ipad':
        domain => 'com.apple.ImageCapture',
        key    => 'disableHotPlug',
        type   => 'bool',
        value  => true,
    }

    macdefaults { 'crash-report-use-notification':
        domain => 'com.apple.CrashReporter',
        key    => 'UseUNC',
        type   => 'bool',
        value  => true,
    }

    macdefaults { 'disable-two-fingers-goback-in-chrome':
        domain => 'com.google.Chrome.plist',
        key    => 'AppleEnableSwipeNavigateWithScrolls ',
        type   => 'bool',
        value  => false,
    }

    macdefaults { 'disable-auto-spelling-correction':
        domain => 'NSGlobalDomain',
        key    => 'NSAutomaticSpellingCorrectionEnabled',
        type   => 'bool',
        value  => false,
    }

    macdefaults { 'show-full-path-in-finder':
        domain => 'com.apple.finder',
        key    => '_FXShowPosixPathInTitle',
        type   => 'bool',
        value  => true,
        notify => Exec[restart_finder],
    }

}

####################
# System
####################
# TODO: Caps Lock => Control

####################
# Chinese
####################
# TODO: wechat
# TODO: sougou input method http://pinyin.sogou.com/mac/softdown.php

####################
# Common dot files
####################
# default top editorconfig
file { "${home}/.editorconfig":
    ensure => 'file',
    source => 'https://gist.githubusercontent.com/robturtle/485da1547ccd96a76e3061e6ba189777/raw/6dc6dd37224c5909348e8261dbcfeecc0653edeb/.editorconfig',
}

# install vim
vcsrepo { "${home}/.vim/bundle/Vundle.vim":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/VundleVim/Vundle.vim.git',
}
# TODO: use Augeas
-> file { "${home}/.vimrc":
    ensure  => present,
    source  => 'https://gist.githubusercontent.com/robturtle/8b424daa53cf73e7e102e5d69dc8a908/raw/4cbb4fd26bfa676d6bb78e2824ebdd42e43c87cd/.vimrc',
}

# install oh-my-zsh
vcsrepo { "${home}/.oh-my-zsh":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/robbyrussell/oh-my-zsh',
    notify   => Exec['change_shell'],
}
-> file { "${home}/.zshrc":
    require => Package['powerline'],
    ensure => present,
    source => 'https://gist.githubusercontent.com/robturtle/1ff2228bd10387d39ec22e5ba27c66ce/raw/a2bd3dafc3a8333e613dce423641b84a2252355d/.zshrc',
}
# TODO: follows $ZSH_CUSTOM folder
# my collection of awesome interactive features powered by Percol
-> vcsrepo { "${home}/config/zsh/plugins/percol":
    ensure   => present,
    provider => git,
    source   => 'https://github.com/robturtle/percol.plugin.zsh',
}

# SHOULD manually call this
exec { "change_shell":
    command     => "chsh -s /bin/zsh ${::id}",
    path        => '/usr/bin:/bin',
    refreshonly => true,
}

####################
# Common softwares
####################
# a great CLI file manager
package { 'ranger':
    provider => 'brew',
}

# a better configured vim
package { 'vim': }

# git relative
file { "${home}/.gitconfig":
    ensure => file,
    source => 'https://gist.githubusercontent.com/robturtle/732f1cbef1b0e7839e1338f0c019e004/raw/82243f7ec6f8c226e0c7008531a1343d0ed242a1/.gitconfig',
}
# Those lazy module authors never thought their mod will be used in OSX. :thumb_down:
-> exec { 'set_git_user_name':
    command => 'git config user.name Yang\ Liu',
    path    => '/usr/local/bin:/usr/bin',
}
-> exec { 'set_git_user_email':
    command => 'git config user.email jeremyrobturtle@gmail.com',
    path    => '/usr/local/bin:/usr/bin',
}

# TODO: manage alias
package { 'hub': }
package { 'git-extras': }

# utils
package { 'tree': }

####################
# PostgreSQL
####################
package { 'postgresql': }
package { 'postgis': }


####################
# IntelliJ
####################
file { "${home}/.ideavimrc":
    ensure  => present,
    content => "source ~/.vimrc\nset visualbell\nset noerrorbells\n",
}

####################
# Github
####################
# TODO: setup https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#adding-your-ssh-key-to-the-ssh-agent

####################
# Python
####################
package { ['python', 'python3']: }

if $::osfamily == 'Darwin' {
    file { '/usr/local/bin/pip':
        require => Package['python'],
        ensure  => 'link',
        replace => 'no',
        target  => '/usr/local/bin/pip2',
        notify  => Package['powerline'],
    }
}

# ipython3
package { 'ipython':
    provider => pip3,
    require  => Package['python3'],
}

# You will need this if u type fast with many typos
# The joke: https://github.com/nvbn/thefuck/issues/251 
#package { 'thefuck':
#    provider => pip3,
#    require  => Package['python3'],
#}
# TODO -> configure thefuck in zsh with Augaes

####################
# Ruby
####################
package { 'rbenv': }

####################
# powerline 
####################
# NOTE: there's bug if installing it with pip3
package { 'powerline':
    name     => 'powerline-status',
    provider => pip,
    require  => Package['python'],
}
# TODO: notify vim setup powerline only it's installed

if $::osfamily == 'Darwin' {
    $font_dir = "${home}/Library/Fonts"
} else {
    $font_dir = "${home}/.local/share/fonts"
}

file { $font_dir:
    ensure => 'directory',
}
-> file { "${font_dir}/Noto Mono for Powerline.ttf": # TODO: Heira to choose other font
    ensure => present,
    source => 'https://cdn.rawgit.com/powerline/fonts/641d35fe/NotoMono/Noto%20Mono%20for%20Powerline.ttf',
} # TODO: iTerm set responding font

# TODO: modify vimrc
# TODO: modify zshrc
# TODO: modify ipython prompt

####################
# Percol
####################
# NOTE: there's bug if installing it with pip3
package { 'percol':
    name     => 'percol',
    provider => pip,
    require  => Package['python'],
}
-> file { "${home}/.percol.d/rc.py":
    ensure => present,
    source => 'https://gist.githubusercontent.com/robturtle/f0acbd4f3a35d4a3a3d04513e7a6310c/raw/777d2fdcb9fa5d60970d99dea627ef9a20339cd9/.percol.d_rc.py',
}
