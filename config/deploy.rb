# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "pushkin-constest-bot"
set :repo_url, "git@github.com:DDKatch/pushkin-contest-bot.git"

# Default branch is :master
ask :deploy, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/deploy/pushkin-constest-bot"

set :rails_env, 'production'
set :rvm_type, :user
set :rvm_ruby_version, '2.3.3'


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5