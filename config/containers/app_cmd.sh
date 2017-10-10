#!/usr/bin/env bash

# Conditionally precompile assets
[ -z 'PRECOMPILE_ASSETS' ] && bundle exec assets:precompile

# Prefix `bundle` with `exec` so unicorn shuts down gracefully on SIGTERM (i.e. `docker stop`)
exec bundle exec unicorn -c config/containers/unicorn.rb -E $RAILS_ENV