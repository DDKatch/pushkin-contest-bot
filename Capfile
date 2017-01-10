# Load DSL and set up stages
require "capistrano/setup"
require 'capistrano/rvm'
require "capistrano/scm/git"
require "capistrano/deploy"
require "capistrano/rails"
require 'capistrano/puma'
# require 'capistrano/puma/nginx'

install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
