require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  nodejs::version { '4.0.0': }

  # default ruby versions
  ruby::version { '2.4.0': }

  # my modules
  include homebrew
  include brewcask
  include zsh
  include ohmyzsh
  include atom

  # clojure
  atom::package { 'Parinfer': }
  atom::package { 'highlight-selected': }
  atom::package { 'ink': }
  atom::package { 'linter': }
  atom::package { 'lisp-paredit': }
  atom::package { 'proto-repl': }
  atom::package { 'proto-repl-charts': }
  atom::package { 'set-syntax': }
  atom::package { 'tool-bar': }

  # puppet
  atom::package { 'language-puppet': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'leiningen'
    ]:
  }

  package {'appcleaner': provider => 'brewcask'}
  package {'robomongo': provider => 'brewcask'}

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
