class people::kwakbab::config::git {
  git::config::global { 'user.name':
    value => "lester-thx"
  }

  git::config::global { 'user.email':
    value  => "lester.thx@kakaocorp.com"
  }

  git::config::global { 'push.default':
    value  => "simple"
  }

  git::config::global { 'alias.st':
    value  => "status"
  }

  git::config::global { 'alias.ci':
    value  => "commit"
  }

  git::config::global { 'alias.co':
    value  => "checkout"
  }

  git::config::global { 'alias.br':
    value  => "branch"
  }

# my
  git::config::global { 'alias.rv':
    value  => "remote -v"
  }

}