if $::osfamily == 'Darwin' {
    Package {
        provider => 'brew',
    }
    $home = "/Users/${::id}"
} else {
    $home = "/home/${::id}"
}

if $::osfamily == 'Darwin' {
    # Mac System-wise Emacs Key Bindings  
    file { "${home}/Library/KeyBindings/DefaultKeyBinding.dict":
        ensure => present,
        source =>
        'https://gist.githubusercontent.com/cheapRoc/9670905/raw/1c1cd2e84daf07c9a4c8de0ff86d1baf75d858c6/EmacsKeyBinding.dict',
    }

    # install homebrew
    class { 'homebrew':
        user  => $::id,
        group => 'staff',
    }
}

####################
# Common dot files
####################
# default top editorconfig
file { "${home}/.editorconfig":
    ensure => 'file',
    source =>
    'https://gist.githubusercontent.com/robturtle/485da1547ccd96a76e3061e6ba189777/raw/6dc6dd37224c5909348e8261dbcfeecc0653edeb/.editorconfig',
}
# use temaplate
# TODO: .gitconfig

# use Augeas
# TODO: .vimrc
# TODO: .zshrc

####################
# Common softwares
####################
# a great CLI file manager
package { 'ranger': }

# a better configured vim
package { 'vim': }

# git relative
# TODO: manage alias
package { 'hub': }
package { 'git-extras': }

# utils
package { 'tree': }

####################
# Github
####################
# TODO: setup https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#adding-your-ssh-key-to-the-ssh-agent

####################
# Python
####################
package { ['python', 'python3']: }

# ipython3
package { 'ipython':
    provider => pip3,
    require  => Package['python3'],
}

####################
# powerline 
####################
package { 'powerline':
    name     => 'powerline-status',
    provider => pip,
    require  => Package['python'],
}

if $::osfamily == 'Darwin' {
    $font_dir = "${home}/Library/Fonts"
} else {
    $font_dir = "${home}/.local/share/fonts"
}

file { $font_dir:
    ensure => 'directory',
} ->
file { "${font_dir}/Noto Mono for Powerline.ttf": # TODO: Heira to choose other font
    ensure => present,
    source => 
    'https://cdn.rawgit.com/powerline/fonts/641d35fe/NotoMono/Noto%20Mono%20for%20Powerline.ttf',
} # TODO: iTerm set responding font

# TODO: modify vimrc
# TODO: modify zshrc
# TODO: modify ipython prompt

####################
# Percol
####################
# TODO: percol.d
# TODO: percol function zsh plugin
