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
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

