server "78.155.207.109", user: "ddkatch", roles: %w{app db web}

set :ssh_options, {
  keys: %w(~/.ssh/id_rsa),
  forward_agent: true
}
