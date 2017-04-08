#!/bin/bash
if [ -x clean.sh ]; then
    clean.sh
fi

echo "Installing"
bundle install

echo "Launching preview"
bundle exec rake preview
