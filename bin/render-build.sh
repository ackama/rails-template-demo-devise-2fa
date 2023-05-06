#!/usr/bin/env bash
# exit on error
set -o errexit

set -e
set -x

echo "====================================================="
echo "Starting bin/render-build.sh"
echo "====================================================="

bundle install
yarn install --frozen-lockfile

# we load dotenv/now in all envs so this file must exist
# this is a bit of a hack. If this was a real app we should probably change
# where dotenv is loaded.
touch .env

bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

