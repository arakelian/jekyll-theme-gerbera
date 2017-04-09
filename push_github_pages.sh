#!/bin/bash
jekyll build --source example/ --baseurl /jekyll-theme-gerbera
RETVAL=$?
if (($RETVAL > 0)); then
    exit 1
fi

# gh-pages should already exist
echo "Checking if gh-pages branch exists locally"
if git ls-remote --exit-code origin "refs/heads/gh-pages" ; then
    # make sure we have latest version
    echo "Make sure local gh-pages is up-to-date"
    git fetch --force origin gh-pages:gh-pages
fi

if git show-ref --verify --quiet "refs/heads/gh-pages" ; then
    git symbolic-ref HEAD refs/heads/gh-pages
    git --work-tree "example/_site" reset --mixed --quiet
    git --work-tree "example/_site" add --all
    git --work-tree "example/_site" commit -m "Committing"
    git symbolic-ref HEAD refs/heads/master
    git reset --mixed --quiet
fi
