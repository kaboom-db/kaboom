#!/usr/bin/env puma

directory "/home/sites/kaboom/current"
rackup "/home/sites/kaboom/current/config.ru"
environment "production"

tag ""

pidfile "/home/sites/kaboom/shared/tmp/pids/puma.pid"
state_path "/home/sites/kaboom/shared/tmp/pids/puma.state"
stdout_redirect "/home/sites/kaboom/shared/log/puma_access.log", "/home/sites/kaboom/shared/log/puma_error.log", true

threads 0, 5

bind "unix:///home/sites/kaboom/shared/tmp/sockets/puma.sock"

workers 6

restart_command "bundle exec puma"

prune_bundler

on_restart do
  puts "Refreshing Gemfile"
  ENV["BUNDLE_GEMFILE"] = ""
end
